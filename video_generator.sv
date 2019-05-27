
module video_generator(	input logic Clock_14Mhz, Clock_7Mhz, ld194, ldps_n, FLASH_CLOCK,
								input logic Reset,
								input logic [6:0] H,
								input logic [8:0] V,
								input logic [7:0] Dl,
								input logic color_ref, hires_mode, text_mode, mix_mode, page2, ras_n,
								output logic HIRES, color_line, HBL, VBL, video_data
								);
								
logic V_SYNC, H_SYNC, SYNC,
		color_burst,
		blanking,
		picture_signal;

logic VA, VB, VC;
logic q_a9, q_a9_n, st_n;

assign VA = V[0];
assign VB = V[1];
assign VC = V[2];
		
assign HBL = ~((H[5]) | (H[3] & H[4]));
assign color_burst = ((text_mode | color_ref) & H[3] & HBL & H[2]);
//assign V_SYNC = (~V[2] & ) & ((H[4]|H[5])) & (V[3] & V[4]);
assign blanking = HBL | (V[6] & V[7]);
assign VBL = V[6] & V[7];
assign V_SYNC = VBL & V[5] & (~V[4]) & (~V[3]) & (~V[2]) & (H[4] | H[3] | H[5]);
assign H_SYNC = HBL & H[3] & ~H[2];
assign SYNC = ~(V_SYNC | H_SYNC);

logic [3:0] DATA_WIDTH;
logic [3:0] q_b4, q_b9, q_a10, q_a8, p0_a8, p1_a8;
logic a9_0, a9_1, a9_2,
		out_A12,
		a8_sel,
		q_b5,
		q_b8_1,
		q_b8_2,
		soft_5;

logic [5:0] a3_p, a3_q;
logic inv_clock_7Mhz;
assign inv_clock_7Mhz = ~Clock_7Mhz;

assign soft_5 = 1'b1;
assign DATA_WIDTH = 4'h4;

logic [8:0] char_rom_addr;
logic [4:0] char_rom_dout;
assign char_rom_addr = {Dl[5:0], VC, VB, VA};

character_rom char_rom0(.addr(char_rom_addr),
 							   .clk(Clock_14Mhz),
							   .q(char_rom_dout));

// A3
always_ff @ (posedge Clock_14Mhz)
begin
	if (~Clock_7Mhz) begin
		if (~ldps_n) begin
			a3_q <= {char_rom_dout, 1'b0};
		end
		else begin
			a3_q <= {1'b0, a3_q[5:1]};
		end
	end

end

logic invert_character;

//debug flashing
//always_comb
//begin
//	a3_p = a3_q;
//end

//always_ff @ (posedge Clock_14Mhz)
//begin
//	if (~ld194) begin
//		invert_character <= ~(Dl[7] | (Dl[6] & FLASH_CLOCK));
//	end
//end

assign invert_character = ~(Dl[7] | (Dl[6] & FLASH_CLOCK));

logic text_out;
assign text_out = (a3_q[0] ^ q_a10[3]);
	

//logic color_line;
assign color_line = q_b5;
//assign color_line = ~((V[5] & V[7] & mix_mode) | text_mode);
	

// B5
flip_flop b5(.Clk(ras_n),
				 .Reset(Reset),
				 .preset_n(1'b1),
				 .p(~((V[5] & V[7] & mix_mode) | text_mode)),
				 .clear_n(soft_5),
				 .q(q_b5),
				 .q_n()
				 );

// B8_1
flip_flop b8_1(.Clk(ras_n),
				 .Reset(Reset),
				 .preset_n(1'b1),
				 .p(q_b5),
				 .q(q_b8_1),
				 .clear_n(soft_5),
				 .q_n()
				 );

// B8_2
flip_flop b8_2(.Clk(ras_n),
				 .Reset(Reset),
				 .preset_n(1'b1),
				 .p(q_b8_1),
				 .q(q_b8_2), 
				 .clear_n(soft_5),
				 .q_n()
				 );

logic hires;
assign hires = hires_mode & q_b8_2;	
assign HIRES = hires;	

assign out_A12 = ~((hires_mode) | ~(q_b8_2 | q_b8_2));
//assign out_A12 = ~hires_mode & q_b8_2;
// A11 flip-flop 0
logic q_a11_0;
always_comb
begin
	if (~out_A12) begin
		q_a11_0 = 1'b1;
	end
	else begin
		q_a11_0 = 1'b0;
	end
end


// A11 flip-flop 1
logic q_a11_1;
always_ff @ (posedge Clock_14Mhz)
begin
	q_a11_1 <= q_b4[0];
end

// A10
shift_reg_ls194 a10(.Clk(Clock_14Mhz),
						.clear(1'b1),
						.SRSI(1'b0),
						.SLSI(),
						.s1(ld194),
						.s0(ld194),
						.p({invert_character, blanking, q_a8[3], q_a8[1]}),
						.q(q_a10)
						);	
	
	
//// B4
shift_reg_ls194 b4(.Clk(Clock_14Mhz),
						.clear(1'b1),
						.SRSI(1'b0),
						.SLSI(q_a8[0]),
						.s1(q_a8[2]),
						.s0(ld194),
						.p(Dl[3:0]),
						.q(q_b4)
						);
// B9
shift_reg_ls194 b9(.Clk(Clock_14Mhz),
						.clear(1'b1),
						.SRSI(1'b0),
						.SLSI(q_b9[0]),
						.s1(q_a8[2]),
						.s0(ld194),
						.p(Dl[7:4]),
						.q(q_b9)
						);


//b4b9 shift register
//logic [7:0] b4b9_reg;			
//always_ff @(posedge Clock_14Mhz) begin
//	if(~ld194)
//		b4b9_reg <= Dl;
//	else if(out_A12)
//		b4b9_reg <= {b4b9_reg[4], b4b9_reg[7:5], b4b9_reg[0], b4b9_reg[3:1]};
//	else if(~Clock_7Mhz)
//		b4b9_reg <= {b4b9_reg[4], b4b9_reg[7:1]};
//end

// A8
//always_ff @(posedge Clock_14Mhz)
always_comb
begin
	p0_a8[0] = q_b4[0];
	p0_a8[1] = VC;
	p0_a8[2] = soft_5;
	p0_a8[3] = H[0];
	
	p1_a8[0] = q_b9[0];
	p1_a8[1] = q_b5;
	p1_a8[2] = ~Clock_7Mhz;
	p1_a8[3] = Dl[7];

	a8_sel= q_a11_0;
	if(a8_sel)
	begin
		q_a8 = p1_a8;
	end
	else begin
		q_a8 = p0_a8;
	end

end

// A9 & B10

// B10

always_ff @ (posedge Clock_14Mhz)
begin
	video_data <= q_a9;
end

//assign video_data = q_a9;

assign st_n = q_a10[2];
logic [2:0] a9_sel;
//always_ff @(posedge Clock_14Mhz)
always_comb
begin

	a9_0 = q_a10[1];
	a9_1 = q_a10[0];
	a9_2 = out_A12;

	a9_sel = {a9_2, a9_1, a9_0};
	case(a9_sel)
		
		3'h0:
			q_a9 = text_out;//q_a9 = a3_q[0]; //fixed text flashing
		3'h1:
//			q_a9 = a3_q[0];
			q_a9 = text_out;
		3'h2:
//			q_a9 = text_out;
			q_a9 = q_b4[0];
		3'h3:
			q_a9 = q_a11_1;
		3'h4:
			q_a9 = q_b4[0];
		3'h5:
			q_a9 = q_b4[2];
		3'h6:
			q_a9 = q_b9[0];
		3'h7:
			q_a9 = q_b9[2];
	
	endcase
	
	if (st_n) begin
		q_a9 = 1'b0;
	end
	
	q_a9_n = ~q_a9;

end

endmodule
