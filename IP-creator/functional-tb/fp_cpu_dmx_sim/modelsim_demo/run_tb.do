onbreak {quit -code 1}
if {[file exists work]} { vdel -lib work -all }
vlib work
vmap work work
transcript on

vlog -sv -timescale 1ns/1ps -work work -f "fp_cpu_files.f"

set vsim_cmd "vsim -quiet -onfinish stop work.tb_cpu_generic"
eval $vsim_cmd
run -all
quit -code 0
