module apple_2e_testbench();

timeunit 10ns;
timeprecision 1ns;

logic Clock_50Mhz,
		RESET_N;
logic [15:0] PC_DEBUG, cpu_addr;
logic [7:0]	OPCODE_DEBUG, io_select, device_select, cpu_data_out, keyboard_data_l, peripheral_out;
logic color_line, HBL, VBL, video_data, ld194, Clock_14Mhz, read_key, q3, pre_phase0, FLASH_CLOCK;
		
always begin
	#1 Clock_50Mhz = ~Clock_50Mhz;
end

apple_2e apple(.*);

initial begin
	Clock_50Mhz = 0;
	RESET_N = 1;
	#2 RESET_N = 0;
	#20 RESET_N = 1; //hold for a long time?
end

endmodule
