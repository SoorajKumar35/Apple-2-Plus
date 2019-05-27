// Won't compile because I changed clock generator input/output to work with ram and cpu - Austin
//module clock_testbench();
//
//timeunit 10ns;
//timeprecision 1ns;
//
//logic CLOCK_50,
//		RESET;
//
//always begin
//	#1 CLOCK_50 = ~CLOCK_50;
//end
//
//initial begin
//	CLOCK_50 = 0;
//end
//
//clock_generator c_g0(.*);
//
//
//initial begin
//	RESET = 1'b1;
//	#12 RESET = 1'b0;
//end
//
//endmodule
