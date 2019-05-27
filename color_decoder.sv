//
//module color_decoder(input logic Clk,
//									logic reset,
//									logic video_signal);
//
//						
//					
//// Line-doubler logic
//// How many bits per line - need to define size of register
//// What info do you need to know from the HBL?
//// Should the output of the two lines be to the color decoder?
//// How does the color_decoder finally write to the screen?
//// How do we control the mode? - the processor probably controls the mode
//// but how does it do so?
//
//// For text mode and mixed, it should pull from the ascii table to write
//// to screen I think - we don't use dot matrices anymore
//
//// How do write pixels to the screen? - could look at the VGA controls on
//// lab8 -> that used the pins to write the colors and the balls to the 
//// screen I think
//	
//
//logic dark_red_p,
//		dark_blue_p,
//		dark_blue_green_p,
//		dark_brown_p;
//		
//logic dark_red_q,
//		dark_blue_q,
//		dark_blue_green_q,
//		dark_brown_q;
//		
//logic color_select,
//		white_select,
//		gray_select,
//		black_select;
//		
//logic pixel_out;
//	
//logic [2:0] phase_angle;
//
//logic [23:0] color;
//
//// Permute shift reg
//// NOTE:
//// Is this always on posedge?
//
//// which clock is driving the shift register
//// and the permute block?
//
//// Which direction is the register shifting up to down or
//// the other way?
//always_ff @ (posedge Clk)
//begin
//	{dark_red_q, dark_blue_q, dark_blue_green_q, dark_brown_q} =
//	{dark_blue_q, dark_blue_green_q, dark_brown_q, dark_red_q};
//end
//
//// Shift-register
//// Which clock shifts this register?
//// Ans: I think the 14M since the 14 shifts the shift register
//// and fills it with one bit of the video signal
//logic [5:0] q, p;
//always_ff @ (posedge Clk)
//begin
//	if (reset) begin
//		q <= 6'b0;
//	end
//		q <= {p[4:0], video_signal};
//end
//
//always_comb
//begin
//	p = q;
//
//end
//
//assign color_select = (~(q[4] ^ q[0]) & ~(q[5] ^ q[1]));
//assign white_select = (q[2] & q[3]);
//assign gray_select = (q[2] | q[3]);
//assign black_select = (~q[2] & ~q[3]);
//
//assign color = (q[4] & dark_red_q) + (q[3] & dark_blue_q) +
//					(q[2] & dark_blue_green_q) + (q[1] & dark_brown_q);
//					
//
//// Color MUX
//always_ff @ (posedge Clk)
//begin
//
//end
//
//always_comb
//begin
//	
//end
//
//
//endmodule
