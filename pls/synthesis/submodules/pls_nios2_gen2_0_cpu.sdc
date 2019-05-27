# Legal Notice: (C)2019 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	pls_nios2_gen2_0_cpu 	pls_nios2_gen2_0_cpu:*
set 	pls_nios2_gen2_0_cpu_oci 	pls_nios2_gen2_0_cpu_nios2_oci:the_pls_nios2_gen2_0_cpu_nios2_oci
set 	pls_nios2_gen2_0_cpu_oci_break 	pls_nios2_gen2_0_cpu_nios2_oci_break:the_pls_nios2_gen2_0_cpu_nios2_oci_break
set 	pls_nios2_gen2_0_cpu_ocimem 	pls_nios2_gen2_0_cpu_nios2_ocimem:the_pls_nios2_gen2_0_cpu_nios2_ocimem
set 	pls_nios2_gen2_0_cpu_oci_debug 	pls_nios2_gen2_0_cpu_nios2_oci_debug:the_pls_nios2_gen2_0_cpu_nios2_oci_debug
set 	pls_nios2_gen2_0_cpu_wrapper 	pls_nios2_gen2_0_cpu_debug_slave_wrapper:the_pls_nios2_gen2_0_cpu_debug_slave_wrapper
set 	pls_nios2_gen2_0_cpu_jtag_tck 	pls_nios2_gen2_0_cpu_debug_slave_tck:the_pls_nios2_gen2_0_cpu_debug_slave_tck
set 	pls_nios2_gen2_0_cpu_jtag_sysclk 	pls_nios2_gen2_0_cpu_debug_slave_sysclk:the_pls_nios2_gen2_0_cpu_debug_slave_sysclk
set 	pls_nios2_gen2_0_cpu_oci_path 	 [format "%s|%s" $pls_nios2_gen2_0_cpu $pls_nios2_gen2_0_cpu_oci]
set 	pls_nios2_gen2_0_cpu_oci_break_path 	 [format "%s|%s" $pls_nios2_gen2_0_cpu_oci_path $pls_nios2_gen2_0_cpu_oci_break]
set 	pls_nios2_gen2_0_cpu_ocimem_path 	 [format "%s|%s" $pls_nios2_gen2_0_cpu_oci_path $pls_nios2_gen2_0_cpu_ocimem]
set 	pls_nios2_gen2_0_cpu_oci_debug_path 	 [format "%s|%s" $pls_nios2_gen2_0_cpu_oci_path $pls_nios2_gen2_0_cpu_oci_debug]
set 	pls_nios2_gen2_0_cpu_jtag_tck_path 	 [format "%s|%s|%s" $pls_nios2_gen2_0_cpu_oci_path $pls_nios2_gen2_0_cpu_wrapper $pls_nios2_gen2_0_cpu_jtag_tck]
set 	pls_nios2_gen2_0_cpu_jtag_sysclk_path 	 [format "%s|%s|%s" $pls_nios2_gen2_0_cpu_oci_path $pls_nios2_gen2_0_cpu_wrapper $pls_nios2_gen2_0_cpu_jtag_sysclk]
set 	pls_nios2_gen2_0_cpu_jtag_sr 	 [format "%s|*sr" $pls_nios2_gen2_0_cpu_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$pls_nios2_gen2_0_cpu_oci_break_path|break_readreg*] -to [get_keepers *$pls_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from [get_keepers *$pls_nios2_gen2_0_cpu_oci_debug_path|*resetlatch]     -to [get_keepers *$pls_nios2_gen2_0_cpu_jtag_sr[33]]
set_false_path -from [get_keepers *$pls_nios2_gen2_0_cpu_oci_debug_path|monitor_ready]  -to [get_keepers *$pls_nios2_gen2_0_cpu_jtag_sr[0]]
set_false_path -from [get_keepers *$pls_nios2_gen2_0_cpu_oci_debug_path|monitor_error]  -to [get_keepers *$pls_nios2_gen2_0_cpu_jtag_sr[34]]
set_false_path -from [get_keepers *$pls_nios2_gen2_0_cpu_ocimem_path|*MonDReg*] -to [get_keepers *$pls_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from *$pls_nios2_gen2_0_cpu_jtag_sr*    -to *$pls_nios2_gen2_0_cpu_jtag_sysclk_path|*jdo*
set_false_path -from sld_hub:*|irf_reg* -to *$pls_nios2_gen2_0_cpu_jtag_sysclk_path|ir*
set_false_path -from sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$pls_nios2_gen2_0_cpu_oci_debug_path|monitor_go
