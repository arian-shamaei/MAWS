package dmx

import chisel3._
import chisel3.experimental.ExtModule
import chisel3.stage.ChiselStage
import chisel3.util._
import scala.language.reflectiveCalls

import scala.io.Source
import scala.util.parsing.combinator._
import java.nio.file.{Files, Paths}
import java.nio.charset.StandardCharsets

object EmitDmx {

  object JsonParser extends JavaTokenParsers {
    def obj: Parser[Map[String, Any]] =
      "{" ~> repsep(member, ",") <~ "}" ^^ (Map() ++ _)
    def arr: Parser[List[Any]] =
      "[" ~> repsep(value, ",") <~ "]"
    def member: Parser[(String, Any)] =
      stringLiteral~":"~value ^^ { case name~":"~value => (name.stripPrefix("\"").stripSuffix("\""), value) }
    def value: Parser[Any] = (
      obj
        | arr
        | stringLiteral ^^ { _.stripPrefix("\"").stripSuffix("\"") }
        | floatingPointNumber ^^ (_.toDouble)
        | "null" ^^ (_ => null)
        | "true" ^^ (_ => true)
        | "false" ^^ (_ => false)
      )

    def parseJson(text: String): Map[String, Any] = parseAll(obj, text) match {
      case Success(result, _) => result
      case _                  => throw new RuntimeException("Invalid JSON")
    }
  }

  final case class FormatCfg(id: Int, name: String, exp: Int, sig: Int)
  final case class BlockCfg(
      name: String,
      top: String,
      fmt: Int,
      aWidth: Int,
      bWidth: Int,
      cWidth: Int,
      outWidth: Int,
      excWidth: Int,
      hasC: Boolean,
      hasSubOp: Boolean,
      hasRound: Boolean,
      roundWidth: Int,
      hasClock: Boolean,
      hasReset: Boolean,
      hasOpSel: Boolean)
  final case class OpCfg(
      name: String,
      opcode: Int,
      fmt: Int,
      block: String,
      usesSubOp: Boolean,
      usesRound: Boolean,
      usesC: Boolean)
  final case class Cfg(
      system: String,
      tidWidth: Int,
      busWidth: Int,
      formats: Seq[FormatCfg],
      blocks: Seq[BlockCfg],
      ops: Seq[OpCfg])

  private def widthOf(inputs: List[Map[String, Any]], name: String, default: Int): Int = {
    inputs
      .find(_("name") == name)
      .flatMap(m => m.get("width"))
      .map(_.asInstanceOf[Double].toInt)
      .getOrElse(default)
  }

  private def hasInput(inputs: List[Map[String, Any]], name: String): Boolean =
    inputs.exists(_("name") == name)

  private def widthOfOut(outputs: List[Map[String, Any]], name: String, default: Int): Int =
    outputs
      .find(_("name") == name)
      .flatMap(m => m.get("width"))
      .map(_.asInstanceOf[Double].toInt)
      .getOrElse(default)

  private def readCfg(path: String): Cfg = {
    val text = Source.fromFile(path).mkString
    val m = JsonParser.parseJson(text)
    val system = m("system").asInstanceOf[String]
    val tidWidth = m.getOrElse("tidWidth", 4.0).asInstanceOf[Double].toInt
    val busWidth = m.getOrElse("busWidth", 64.0).asInstanceOf[Double].toInt
    val formatsRaw = m.getOrElse("formats", List.empty[Any]).asInstanceOf[List[Map[String, Any]]]
    val formats = formatsRaw.map { f =>
      FormatCfg(
        f("id").asInstanceOf[Double].toInt,
        f.getOrElse("name", s"fmt${f("id")}").asInstanceOf[String],
        f.getOrElse("exp", 8.0).asInstanceOf[Double].toInt,
        f.getOrElse("sig", 24.0).asInstanceOf[Double].toInt
      )
    }
    val blocksRaw = m("blocks").asInstanceOf[List[Map[String, Any]]]
    val blocks = blocksRaw.map { b =>
      val manifest = b.get("manifest").map(_.asInstanceOf[Map[String, Any]]).getOrElse(Map.empty)
      val inputs = manifest.get("inputs").map(_.asInstanceOf[List[Map[String, Any]]]).getOrElse(Nil)
      val outputs = manifest.get("outputs").map(_.asInstanceOf[List[Map[String, Any]]]).getOrElse(Nil)
      BlockCfg(
        b("name").asInstanceOf[String],
        b("top").asInstanceOf[String],
        b.getOrElse("fmt", 0.0).asInstanceOf[Double].toInt,
        widthOf(inputs, "io_a", busWidth),
        widthOf(inputs, "io_b", busWidth),
        widthOf(inputs, "io_c", busWidth),
        widthOfOut(outputs, "io_out", busWidth),
        widthOfOut(outputs, "io_exceptionFlags", 5),
        hasInput(inputs, "io_c"),
        hasInput(inputs, "io_subOp"),
        hasInput(inputs, "io_roundingMode"),
        widthOf(inputs, "io_roundingMode", 3),
        hasInput(inputs, "clock"),
        hasInput(inputs, "reset"),
        hasInput(inputs, "io_opSel")
      )
    }
    val opsRaw = m.getOrElse("ops", List.empty[Any]).asInstanceOf[List[Map[String, Any]]]
    val ops = opsRaw.map { o =>
      OpCfg(
        o("name").asInstanceOf[String],
        o("opcode").asInstanceOf[Double].toInt,
        o.getOrElse("fmt", 0.0).asInstanceOf[Double].toInt,
        o("block").asInstanceOf[String],
        o.getOrElse("uses_subOp", false).asInstanceOf[Boolean],
        o.getOrElse("uses_rounding", false).asInstanceOf[Boolean],
        o.getOrElse("uses_c", false).asInstanceOf[Boolean]
      )
    }
    Cfg(system, tidWidth, busWidth, formats, blocks, ops)
  }

  private def write(path: String, body: String): Unit = {
    val p = Paths.get(path)
    Files.createDirectories(p.getParent)
    Files.write(p, body.getBytes(StandardCharsets.UTF_8))
  }

  private def genPkg(cfg: Cfg): String = {
    val fmtLines = cfg.formats.map(f => s"  localparam [1:0] DMX_FMT_${f.id} = 2'd${f.id}; // ${f.name} exp=${f.exp} sig=${f.sig}")
    val opLines = cfg.ops.map(o => s"  localparam [7:0] DMX_OPCODE_${o.name.toUpperCase} = 8'd${o.opcode};")
    s"""|`ifndef DMX_PKG_SV
        |`define DMX_PKG_SV
        |package dmx_pkg;
        |  localparam int DMX_TID_W = ${cfg.tidWidth};
        |  localparam int DMX_BUS_W = ${cfg.busWidth};
${fmtLines.mkString("\n")}
${opLines.mkString("\n")}
        |endpackage
        |`endif
        |""".stripMargin
  }

  private def padTo(value: UInt, targetWidth: Int): UInt = {
    if (value.getWidth >= targetWidth) {
      value(targetWidth - 1, 0)
    } else {
      Cat(0.U((targetWidth - value.getWidth).W), value)
    }
  }

  private class BlockBlackBox(cfg: BlockCfg) extends ExtModule {
    override val desiredName: String = cfg.top

    val clock = IO(Input(Clock()))
    val reset = if (cfg.hasReset) Some(IO(Input(Bool()))) else None
    val io_a = IO(Input(UInt(cfg.aWidth.W)))
    val io_b = IO(Input(UInt(cfg.bWidth.W)))
    val io_c = if (cfg.hasC) Some(IO(Input(UInt(cfg.cWidth.W)))) else None
    val io_subOp = if (cfg.hasSubOp) Some(IO(Input(Bool()))) else None
    val io_roundingMode = if (cfg.hasRound) Some(IO(Input(UInt(cfg.roundWidth.W)))) else None
    val io_opSel = if (cfg.hasOpSel) Some(IO(Input(Bool()))) else None
    val io_out = IO(Output(UInt(cfg.outWidth.W)))
    val io_exceptionFlags = IO(Output(UInt(cfg.excWidth.W)))
  }

  private class DmxWrapper(cfg: Cfg) extends Module {
    override val desiredName: String = s"${cfg.system}_dmx_wrapper"

    val io = IO(new Bundle {
      val instr_valid = Input(Bool())
      val instr_opcode = Input(UInt(8.W))
      val instr_fmt = Input(UInt(2.W))
      val src0_data = Input(UInt(cfg.busWidth.W))
      val src1_data = Input(UInt(cfg.busWidth.W))
      val src2_data = Input(UInt(cfg.busWidth.W))
      val cpu_tid = Input(UInt(cfg.tidWidth.W))
      val csr_rounding_mode = Input(UInt(3.W))
      val csr_tininess_mode = Input(Bool())
      val cpu_req_ready = Output(Bool())
      val cpu_resp_valid = Output(Bool())
      val cpu_resp_tid = Output(UInt(cfg.tidWidth.W))
      val cpu_resp_data = Output(UInt(cfg.busWidth.W))
      val cpu_resp_flags = Output(UInt(5.W))
    })

    io.cpu_resp_tid := io.cpu_tid

    val blockTable: Map[String, (BlockCfg, BlockBlackBox)] = cfg.blocks.map { b =>
      val inst = Module(new BlockBlackBox(b))
      inst.clock := clock
      if (b.hasReset) {
        inst.reset.foreach(_ := reset.asBool)
      }
      inst.io_a := io.src0_data(b.aWidth - 1, 0)
      inst.io_b := io.src1_data(b.bWidth - 1, 0)
      if (b.hasC) {
        inst.io_c.foreach(_ := 0.U(b.cWidth.W))
      }
      inst.io_subOp.foreach(_ := false.B)
      inst.io_roundingMode.foreach(_ := 0.U(b.roundWidth.W))
      inst.io_opSel.foreach(_ := false.B)
      b.name -> (b, inst)
    }.toMap

    val respReady = WireDefault(false.B)
    val respValid = WireDefault(false.B)
    val respData = WireDefault(0.U(cfg.busWidth.W))
    val respFlags = WireDefault(0.U(5.W))

    cfg.ops.foreach { op =>
      val (bCfg, blk) = blockTable(op.block)
      when(io.instr_valid && io.instr_opcode === op.opcode.U && io.instr_fmt === op.fmt.U) {
        respReady := true.B
        respValid := true.B
        if (blk.io_out.getWidth == cfg.busWidth) {
          respData := blk.io_out
        } else {
          respData := padTo(blk.io_out, cfg.busWidth)
        }
        respFlags := blk.io_exceptionFlags
        blk.io_subOp.foreach { s => s := op.usesSubOp.B }
        blk.io_roundingMode.foreach { r =>
          if (op.usesRound) r := io.csr_rounding_mode else r := 0.U(r.getWidth.W)
        }
        blk.io_opSel.foreach { s => s := true.B }
        blk.io_c.foreach { c =>
          if (op.usesC) c := io.src2_data(bCfg.cWidth - 1, 0)
        }
      }
    }

    io.cpu_req_ready := respReady
    io.cpu_resp_valid := respValid
    io.cpu_resp_data := respData
    io.cpu_resp_flags := respFlags
  }

  private class DmxSystem(cfg: Cfg) extends Module {
    override val desiredName: String = s"${cfg.system}_dmx_system"

    val io = IO(new Bundle {
      val clock = Input(Clock())
      val reset_n = Input(Bool())
      val instr_valid = Input(Bool())
      val instr_opcode = Input(UInt(8.W))
      val instr_fmt = Input(UInt(2.W))
      val src0_data = Input(UInt(cfg.busWidth.W))
      val src1_data = Input(UInt(cfg.busWidth.W))
      val src2_data = Input(UInt(cfg.busWidth.W))
      val cpu_tid = Input(UInt(cfg.tidWidth.W))
      val csr_rounding_mode = Input(UInt(3.W))
      val csr_tininess_mode = Input(Bool())
      val cpu_req_ready = Output(Bool())
      val cpu_resp_valid = Output(Bool())
      val cpu_resp_tid = Output(UInt(cfg.tidWidth.W))
      val cpu_resp_data = Output(UInt(cfg.busWidth.W))
      val cpu_resp_flags = Output(UInt(5.W))
    })

    val wrapper = Module(new DmxWrapper(cfg))
    wrapper.clock := io.clock
    wrapper.reset := (~io.reset_n).asBool
    wrapper.io.instr_valid := io.instr_valid
    wrapper.io.instr_opcode := io.instr_opcode
    wrapper.io.instr_fmt := io.instr_fmt
    wrapper.io.src0_data := io.src0_data
    wrapper.io.src1_data := io.src1_data
    wrapper.io.src2_data := io.src2_data
    wrapper.io.cpu_tid := io.cpu_tid
    wrapper.io.csr_rounding_mode := io.csr_rounding_mode
    wrapper.io.csr_tininess_mode := io.csr_tininess_mode

    io.cpu_req_ready := wrapper.io.cpu_req_ready
    io.cpu_resp_valid := wrapper.io.cpu_resp_valid
    io.cpu_resp_tid := wrapper.io.cpu_resp_tid
    io.cpu_resp_data := wrapper.io.cpu_resp_data
    io.cpu_resp_flags := wrapper.io.cpu_resp_flags
  }

  def main(args: Array[String]): Unit = {
    if (args.length < 1 || args.length > 2) {
      println("Usage: runMain dmx.EmitDmx <path/to/dmx_config.json> [out_dir]")
      sys.exit(1)
    }
    val cfgPath = Paths.get(args(0)).toAbsolutePath
    val outDir = if (args.length == 2) Paths.get(args(1)).toAbsolutePath else cfgPath.getParent
    val cfg = readCfg(cfgPath.toString)
    Files.createDirectories(outDir)
    write(outDir.resolve("dmx_pkg.sv").toString, genPkg(cfg))

    val stage = new ChiselStage
    val wrapperSv = stage.emitSystemVerilog(new DmxWrapper(cfg))
    val systemSv = stage.emitSystemVerilog(new DmxSystem(cfg))

    write(outDir.resolve("dmx_wrapper.sv").toString, wrapperSv)
    write(outDir.resolve("dmx_system.sv").toString, systemSv)
    println(s"[EmitDmx] Wrote DMX RTL to $outDir")
  }
}
