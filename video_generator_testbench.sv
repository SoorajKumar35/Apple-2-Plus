
module video_generator_testbench();

timeunit 10ns;
timeprecision 1ns;

logic CLOCK_50,
		RESET;
		
logic text_mode, mix_mode, hires_mode, page2;
logic [7:0] Dl;

always begin
	#1 CLOCK_50 = ~CLOCK_50;
end

initial begin
	CLOCK_50 = 0;
end



video_gen_and_clock_toplevel vgc0(.CLOCK_50(CLOCK_50),
											 .RESET(RESET),
											 .text_mode(text_mode),
											 .hires_mode(hires_mode),
											 .page2(page2),
											 .mix_mode(mix_mode),
											 .Dl(Dl)
											 );


initial begin
	RESET = 1'b1;
	#12 RESET = 1'b0;
	
	
	#4 hires_mode = 1'b0;
	mix_mode = 1'b0;
	page2 = 1'b0;
	text_mode = 1'b1;
	Dl = 8'b00000001;
	
	#250 Dl = 8'h00;

	
end

endmodule



