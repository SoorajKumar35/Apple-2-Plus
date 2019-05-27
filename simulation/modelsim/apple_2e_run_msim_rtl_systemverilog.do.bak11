transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib pls
vmap pls pls
vlog -vlog01compat -work pls +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/pls/synthesis/submodules {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/pls/synthesis/submodules/pls_jtag_uart_0.v}
vlog -sv -work work +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/shift_reg_ls194.sv}
vlog -sv -work work +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/flip_flop.sv}
vlog -sv -work work +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/apple2_rom.sv}
vlog -sv -work work +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/clock_generator.sv}
vlog -sv -work work +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/apple_2e.sv}
vlog -sv -work work +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/video_generator.sv}
vlog -sv -work work +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/single_port_ram.sv}
vlog -sv -work work +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/character_rom.sv}
vcom -93 -work work {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/cpu65xx.vhd}

vlog -sv -work work +incdir+C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project {C:/Users/Admin/Desktop/Spring_2019/ECE_385/ece-385-labs/final_project/apple_2e_testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L pls -voptargs="+acc"  apple_2e_testbench

add wave *
view structure
view signals
run 10000 ns
