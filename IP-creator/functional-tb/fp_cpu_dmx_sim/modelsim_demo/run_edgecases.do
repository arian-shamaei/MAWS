onbreak {quit -code 1}
if {[file exists work]} { vdel -lib work -all }
vlib work
vmap work work
transcript on
vlog -sv -timescale 1ns/1ps -work work -f "fp_cpu_files.f"
vsim -quiet work.tb_fp_cpu_edgecases
run 5 us
quit -code 0
