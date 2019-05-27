transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/sskumar5/Desktop/ece385/ece-385-labs/final_project {C:/Users/sskumar5/Desktop/ece385/ece-385-labs/final_project/clock14Mhz_pll.v}
vlog -vlog01compat -work work +incdir+C:/Users/sskumar5/Desktop/ece385/ece-385-labs/final_project/db {C:/Users/sskumar5/Desktop/ece385/ece-385-labs/final_project/db/clock14mhz_pll_altpll.v}
vlog -sv -work work +incdir+C:/Users/sskumar5/Desktop/ece385/ece-385-labs/final_project {C:/Users/sskumar5/Desktop/ece385/ece-385-labs/final_project/clock_generator.sv}

vlog -sv -work work +incdir+C:/Users/sskumar5/Desktop/ece385/ece-385-labs/final_project {C:/Users/sskumar5/Desktop/ece385/ece-385-labs/final_project/clock_testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  clock_testbench

add wave *
view structure
view signals
run 1000 ns
