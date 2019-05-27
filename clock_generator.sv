
module clock_generator(
	input logic		Clock_50Mhz,
						RESET,
						HI_RES,
						PAGE2,
						clock_14Mhz,
	output logic	phase0,
						pre_phase0,
						rasn_q0,
						casn_q2,
						ax_q1,
						q3,
						clock_7Mhz,
						ldps_n,
						ld194,
						color_ref,
	output logic [6:0] H,
	output logic [8:0] V,
	output logic [15:0] video_addr
);
// This module is used to approximate the clock generator used in the FPGA
// Apple 2e design.

logic p_e_c2;
logic color_delay_N,
		phase1,
		color_ref_n;
logic HBL; //Horizontal blanking
//// We use a PLL module to recreate the 14.31818 MHz signal that drives the 
//// Apple 2e. 
//clock14Mhz_pll c14_pll(.inclk0(Clock_50Mhz),
//							  .c0(clock_14Mhz));
//moved to top level

// Shift register C2
logic rasn_p0, ax_p1, casn_p2, p3;
logic rasn_q0_next, ax_q1_next, casn_q2_next, q3_next;
always_ff @ (posedge clock_14Mhz) begin
	
	if (RESET) begin
		{q3, casn_q2, ax_q1, rasn_q0} <= {1'b0, 1'b0, 1'b0, 1'b0};
	end
	else begin
		if(q3) begin
			{q3, casn_q2, ax_q1, rasn_q0} <= {casn_q2_next, ax_q1_next, rasn_q0_next, 1'b0};
		end
		else begin
			{q3, casn_q2, ax_q1, rasn_q0} <= {p3, casn_p2, ax_p1, rasn_p0};
		end
	end
end

always_comb begin
	rasn_p0 = ax_q1;
	ax_p1 = color_delay_N;
	casn_p2 = ax_q1;
	p3 = rasn_q0;
	
	rasn_q0_next = rasn_q0;
	ax_q1_next = ax_q1;
	casn_q2_next = casn_q2;
	 if (q3) begin
		q3_next = casn_q2_next;
	end else begin
		q3_next = p3;
	end
end

//assign p_e_c2 = q3;


// The clock signals for the video gen, the processors, 
logic clock_3Mhz, clock_1Mhz;
logic clock_7Mhz_next, clock_3Mhz_next, clock_1Mhz_next;
//
//always_ff @ (posedge clock_14Mhz) begin
//	if (RESET) begin
////		clock_7Mhz <= 1'b0;
//		clock_3Mhz <= 1'b0;
//		clock_1Mhz <= 1'b0;
//	end
//	else begin
////		clock_7Mhz = clock_7Mhz_next;
//		if(clock_7Mhz)
//			clock_3Mhz = ~clock_3Mhz;
//		if(clock_3Mhz)
//			clock_1Mhz = ~clock_1Mhz;
//	end
//end

//always_comb begin
//	phase0 = clock_1Mhz;
//	phase1 = ~clock_1Mhz;
//	color_ref = clock_3Mhz;
//	color_ref_n = ~clock_3Mhz;
//end


always_ff @ (posedge clock_14Mhz) begin: B1quadff
	
	if (RESET) begin
		color_ref <= 1'b1;
//		phase0 <= 1'b1;
		pre_phase0 <= 1'b1;
		clock_7Mhz <= 1'b0;
	end
	else begin
		color_ref <= clock_7Mhz ^ color_ref;
		clock_7Mhz <= ~clock_7Mhz_next;
//		phase0 = pre_phase0; // Made this assignment non-blocking due to conflict if ax_q1 is high
		if (ax_q1) begin
			pre_phase0 <= ~(q3_next ^ phase0);
		end
	end
end

assign clock_7Mhz_next = clock_7Mhz;
assign phase0 = pre_phase0;


// Generate once a line hiccup
assign color_delay_N = ~(~color_ref & (~ax_q1 & ~casn_q2) & phase0 & ~H[6]);
assign ldps_n = ~(phase0 & ~ax_q1 & ~casn_q2);
assign ld194 = (phase0 & ~ax_q1 & ~casn_q2 & ~clock_7Mhz);

// Horizontal and Vertical
always_ff @ (posedge clock_14Mhz) begin
	if (RESET) begin
		H <= 7'h40;
		V <= 9'hFA;
	end
	else begin
		if (phase0 & ~ax_q1 & ((q3 & rasn_q0) | (~q3 & color_delay_N))) begin
			if (!H[6]) begin
				H = 7'h40;
			end
			else begin
				H = H + 7'h01;
				if (H == 7'h7f) begin
					V = V + 8'h01;
					if (V == 9'h1FF) V = 9'hFA;
				end
			end
		end
	end
end

assign HBL = !(H[5] | (H[3] & H[4]));

//need HI_RES(signal done but need to generate)
assign video_addr[2:0] = H[2:0];
assign video_addr[6:3] = ({!H[5], V[6], H[4], H[3]}) + ({V[7], !H[5], V[7], 1'b1}) + ({3'b000, V[6]});
assign video_addr[9:7] = V[5:3];
assign video_addr[14:10] = (HI_RES)?({PAGE2, !PAGE2, V[2:0]}):({2'b00, HBL, PAGE2, !PAGE2});
assign video_addr[15] = 1'b0;

endmodule

