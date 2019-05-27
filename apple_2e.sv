module apple_2e(
	input logic RESET_N,
					Clock_50Mhz,
					Clock_14Mhz,
	input logic [7:0] keyboard_data_l,
							peripheral_out,
	output logic [15:0] PC_DEBUG,
								cpu_addr,
	output logic [7:0]	OPCODE_DEBUG,
								io_select,
								device_select,
								cpu_data_out,
	output logic color_line, HBL, VBL, video_data, ld194, read_key, q3, pre_phase0, FLASH_CLOCK
);
	logic RESET;
	//ram signals
	logic [15:0] ram_addr;
	logic [7:0] ram_data_in, ram_data_out, ram_data_out_l;
	logic ram_we;
	
	//rom signals
	logic [13:0] rom_addr;
	logic [7:0] rom_out;
	
	//cpu signals
	logic [7:0] cpu_data_in;
	logic cpu_we; //we

	//timing signals
	logic [6:0] H;
	logic [8:0] V;
	logic [15:0] video_addr;
	logic phase0, ras_n, cas_n, ax, Clock_7Mhz, color_ref, ldps_n;
	
	//softswitch signals
	logic [7:0] soft_switches = 8'b00000000;
	logic TEXT_MODE, MIX_MODE, PAGE2, HIRES_MODE;
	
	//address decoder signals
	logic ram_select = 1'b1;
	logic kbd_select = 1'b0;
	logic rom_select, switch_select, gameport_select;
	
	//video signals
	logic HI_RES;
	
	//init submodules	
	clock_generator c_g0(
		.Clock_50Mhz(Clock_50Mhz),
		.RESET(RESET),
		.HI_RES(HI_RES),
		.PAGE2(PAGE2),
		
		.phase0(phase0),
		.pre_phase0(pre_phase0),
		.rasn_q0(ras_n),
		.casn_q2(cas_n),
		.ax_q1(ax),
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

	
	logic [22:0] flash_clk = 22'd0;
	always_ff @(posedge Clock_14Mhz)
	begin
		flash_clk <= flash_clk + 22'd1;
	end
	
	assign FLASH_CLOCK = flash_clk[22];

	video_generator vid_gen(
		.Reset(RESET),
		.Clock_14Mhz(Clock_14Mhz),
		.Clock_7Mhz(Clock_7Mhz),
		.ld194(ld194),
		.ldps_n(ldps_n),
		.FLASH_CLOCK(flash_clk[22]),
		.H(H),
		.V(V),
		.Dl(ram_data_out_l),
		.color_ref(color_ref),
		.hires_mode(HIRES_MODE),
		.text_mode(TEXT_MODE),
		.mix_mode(MIX_MODE),
		.page2(PAGE2),
		.ras_n(ras_n),

		.HIRES(HI_RES),
		.color_line(color_line),
		.HBL(HBL),
		.VBL(VBL),
		.video_data(video_data)
	);
	
	cpu65xx 
	#(
		.pipelineOpcode(1'b0),
		.pipelineAluMux(1'b0),
		.pipelineAluOut(1'b0)
	)
	cpu(
		.clk(q3),
		.enable(~pre_phase0),
		.reset(RESET),
		.nmi_n(1'b1),
		.irq_n(1'b1),
		.di(cpu_data_in),
		.d_o(cpu_data_out),
		.addr(cpu_addr),
		.we(cpu_we),
		.debugPc(PC_DEBUG),
		.debugOpcode(OPCODE_DEBUG)
	);
	
	assign cpu_data_in = (ram_select)?ram_data_out_l:
								(kbd_select)?keyboard_data_l: //keyboard_out
								(gameport_select)?8'b00000000: //{GAMEPORT[cpu_addr[2:0]], 7'b0000000}:
								(rom_select)?rom_out:
								peripheral_out; //peripheral_out
	
	single_port_ram ram(
		.data(ram_data_in),
		.addr(ram_addr),
		.we(ram_we),
		.clk(Clock_14Mhz), //might need to clock faster. I'm not sure
		.q(ram_data_out)
	);
	
	apple2_rom main_rom(
		.addr(rom_addr),
		.clk(Clock_14Mhz),
		.q(rom_out)
	);
	//ROM logic
	assign rom_addr = {cpu_addr[13] & cpu_addr[12], ~cpu_addr[12], cpu_addr[11:0]};
	
	//RAM logic
	assign ram_addr = (phase0)?cpu_addr:video_addr;
	assign ram_we = (phase0)?(cpu_we && !ras_n):1'b0;
	assign ram_data_in = cpu_data_out; //(ram_we)?cpu_data_out:8'bZ; //I commented this out 
	
	//latch ram data on rising edge of ras
	always_ff @(posedge Clock_14Mhz)
	begin
		if(ax && !cas_n && !ras_n)
			ram_data_out_l <= ram_data_out;
	end
	
	//address decoder logic
	always @(cpu_addr)
	begin
		ram_select <= 1'b0;
		kbd_select <= 1'b0;
		rom_select <= 1'b0;
		read_key <= 1'b0;
		switch_select <= 1'b0;
		gameport_select <= 1'b0;
		io_select <= 8'b0;
		device_select <= 8'b0;
		
		case(cpu_addr[15:14])
			2'b00: ram_select <= 1'b1;
			2'b01: ram_select <= 1'b1;
			2'b10: ram_select <= 1'b1;
			2'b11:
				begin
					case(cpu_addr[13:12])
						2'b00:
							begin
								case(cpu_addr[11:8])
									4'h0:
										begin
											case(cpu_addr[7:4])
												4'h0: kbd_select <= 1'b1;
												4'h1: read_key <= 1'b1;
												4'h3: ;
												4'h4:;
												4'h5: switch_select <= 1'b1;
												4'h6: gameport_select <= 1'b1;
												4'h7: ;
												4'h8: device_select[cpu_addr[6:4]] <= 1'b1;
												4'h9: device_select[cpu_addr[6:4]] <= 1'b1;
												4'hA: device_select[cpu_addr[6:4]] <= 1'b1;
												4'hB: device_select[cpu_addr[6:4]] <= 1'b1;
												4'hC: device_select[cpu_addr[6:4]] <= 1'b1;
												4'hD: device_select[cpu_addr[6:4]] <= 1'b1;
												4'hE: device_select[cpu_addr[6:4]] <= 1'b1;
												4'hF: device_select[cpu_addr[6:4]] <= 1'b1;
												default:;
											endcase
										end
									4'h1: io_select[cpu_addr[10:8]] <= 1'b1;
									4'h2: io_select[cpu_addr[10:8]] <= 1'b1;
									4'h3: io_select[cpu_addr[10:8]] <= 1'b1;
									4'h4: io_select[cpu_addr[10:8]] <= 1'b1;
									4'h5: io_select[cpu_addr[10:8]] <= 1'b1;
									4'h6: io_select[cpu_addr[10:8]] <= 1'b1;
									4'h7: io_select[cpu_addr[10:8]] <= 1'b1;
									4'h8: ;
									4'h9: ;
									4'hA: ;
									4'hB: ;
									4'hC: ;
									4'hD: ;
									4'hE: ;
									4'hF: ;
								endcase
							end
						2'b01: rom_select <= 1'b1;
						2'b10: rom_select <= 1'b1;
						2'b11: rom_select <= 1'b1;
					endcase
				end
		endcase
		
		
	end

	//soft switches logic
	always_ff @(posedge q3)
	begin
		if(pre_phase0 && switch_select)
			soft_switches[cpu_addr[3:1]] <= cpu_addr[0];
	end
	assign TEXT_MODE = soft_switches[0];
	assign MIX_MODE = soft_switches[1];
	assign PAGE2 = soft_switches[2];
	assign HIRES_MODE = soft_switches[3];
	
	assign RESET = ~RESET_N;



endmodule
