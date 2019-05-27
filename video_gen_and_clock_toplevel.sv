
module video_gen_and_clock_toplevel(input logic CLOCK_50, RESET,
												input logic text_mode, mix_mode, hires_mode, page2,
												input logic [7:0] Dl
												);

logic	HI_RES,
		PAGE2,
		phase0,
		pre_phase0,
		rasn_q0,
		casn_q2,
		ax_q1,
		q3;
logic Clock_14Mhz, Clock_7Mhz, ld194, ldps_n, color_ref, FLASH_CLOCK;
logic [15:0] video_addr;
logic [6:0] H;
logic [8:0] V;
logic VA, VB, VC, VD, VE, VF;
logic hires_out;

assign HI_RES = hires_out;
assign PAGE2 = page2;
	
clock_generator c_g0(.CLOCK_50(CLOCK_50),
							.RESET(RESET),
							.HI_RES(HI_RES),
							.PAGE2(PAGE2),
							
							.phase0(phase0),
							.pre_phase0(),
							.rasn_q0(rasn_q0),
							.casn_q2(casn_q2),
							.ax_q1(ax_q1),
							.q3(q3),
							.clock_14Mhz(Clock_14Mhz),
							.clock_7Mhz(Clock_7Mhz),
							.color_ref(color_ref),
							.ldps_n(ldps_n),
							.ld194(ld194),
							.H(H),
							.V(V),
							.video_addr(video_addr)
							);


video_generator vid_gen(.Reset(RESET),
								.Clock_14Mhz(Clock_14Mhz),
								.Clock_7Mhz(Clock_7Mhz),
								.ld194(ld194),
								.ldps_n(ldps_n),
								.FLASH_CLOCK(phase0), // Need low freq clock for flash so decided 1Mhz clock.
															// Need better clock doe.
								.H(H),
								.V(V),
								.Dl(Dl),
								.color_ref(color_ref),
								.hires_mode(hires_mode),
								.text_mode(text_mode),
								.mix_mode(mix_mode),
								.page2(PAGE2),
								.ras_n(rasn_q0),
								
								.HIRES(hires_out)
								);

endmodule
