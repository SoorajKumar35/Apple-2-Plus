module apple2_toplevel(
	input logic RESET_N,
					Clock_50Mhz,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
	output logic [7:0]  VGA_R,        //VGA Red
							VGA_G,        //VGA Green
							VGA_B,        //VGA Blue
	output logic      VGA_CLK,      //VGA Clock
							VGA_BLANK,  //VGA Blank signal
							VGA_VS,       //VGA virtical sync signal
							VGA_HS,
							VGA_SYNC,
	// CY7C67200 Interface
//	inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
//	output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
//	output logic        OTG_CS_N,     //CY7C67200 Chip Select
//							OTG_RD_N,     //CY7C67200 Write
//							OTG_WR_N,     //CY7C67200 Read
//							OTG_RST_N,    //CY7C67200 Reset
//	input               OTG_INT,      //CY7C67200 Interrupt
	// SDRAM Interface for Nios II Software
	output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
	inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
	output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
	output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
	output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
							DRAM_CAS_N,   //SDRAM Column Address Strobe
							DRAM_CKE,     //SDRAM Clock Enable
							DRAM_WE_N,    //SDRAM Write Enable
							DRAM_CS_N,    //SDRAM Chip Select
							DRAM_CLK,      //SDRAM Clock
	output [7:0] 	LEDG,
	output [3:0]	LEDR,
	input logic SD_DAT0,
	output logic SD_DAT3,
	output logic SD_CMD,
					SD_CLK,
	input logic [9:0] SW
);
logic [15:0] PC_DEBUG, cpu_addr;
	logic [7:0]	OPCODE_DEBUG, io_select, cpu_data_out, peripheral_out, device_select;
	logic color_line, HBL, VBL, video_data, ld194, CLK_28M, Clock_14Mhz, read_key, q3, pre_phase0, FLASH_CLOCK;
	apple_2e apple(.*);
	
	logic Reset_h;
	logic [1:0] hpi_addr;
	logic [15:0] hpi_data_in, hpi_data_out;
	logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	logic [7:0] keycode = 8'h00;
	logic [7:0] modifier = 8'h00;
	logic [7:0] ascii;
	logic [7:0] keyboard_data_l;
	logic power_on_reset = 1'b1;
	always_ff @ (posedge Clock_50Mhz) begin
        Reset_h <= (~(RESET_N) | power_on_reset);        // The push buttons are active low
	end
	
	always_ff @(posedge Clock_14Mhz) begin
		if(FLASH_CLOCK)
			power_on_reset <= 1'b0;
	end
	
//	hpi_io_intf hpi_io_inst(
//		.Clk(Clock_50Mhz),
//		.Reset(1'b0),
//		// signals connected to NIOS II
//		.from_sw_address(hpi_addr),
//		.from_sw_data_in(hpi_data_in),
//		.from_sw_data_out(hpi_data_out),
//		.from_sw_r(hpi_r),
//		.from_sw_w(hpi_w),
//		.from_sw_cs(hpi_cs),
//		.from_sw_reset(hpi_reset),
//		// signals connected to EZ-OTG chip
//		.OTG_DATA(OTG_DATA),    
//		.OTG_ADDR(OTG_ADDR),    
//		.OTG_RD_N(OTG_RD_N),    
//		.OTG_WR_N(OTG_WR_N),    
//		.OTG_CS_N(OTG_CS_N),
//		.OTG_RST_N(OTG_RST_N)
//	);
	 
	pls nios_system(
		.clk_clk(Clock_50Mhz),         
		.reset_reset_n(1'b1),    // Never reset NIOS
		.sdram_wire_addr(DRAM_ADDR), 
		.sdram_wire_ba(DRAM_BA),   
		.sdram_wire_cas_n(DRAM_CAS_N),
		.sdram_wire_cke(DRAM_CKE),  
		.sdram_wire_cs_n(DRAM_CS_N), 
		.sdram_wire_dq(DRAM_DQ),   
		.sdram_wire_dqm(DRAM_DQM),  
		.sdram_wire_ras_n(DRAM_RAS_N),
		.sdram_wire_we_n(DRAM_WE_N), 
		.sdram_clk_clk(DRAM_CLK),
		.keycode_export(keycode),
		.modifier_export(modifier),
		.otg_hpi_address_export(hpi_addr),
		.otg_hpi_data_in_port(hpi_data_in),
		.otg_hpi_data_out_port(hpi_data_out),
		.otg_hpi_cs_export(hpi_cs),
		.otg_hpi_r_export(hpi_r),
		.otg_hpi_w_export(hpi_w),
		.otg_hpi_reset_export(hpi_reset)
	);
	
	logic key_pressed, ctrl, shift;
	
	
	
	logic CLK_15Hz;
	
	divider_15Hz div15(
		.CLK_50(Clock_50Mhz),
		.CLK_15Hz(CLK_15Hz)
	);
	
	keyboard kbd(
		.Clock_14Mhz(Clock_14Mhz),
		.CLK_15Hz(CLK_15Hz),
		.keycode(keycode),
		.modifier(modifier),
		.keyboard_data_l(keyboard_data_l),
		.ascii(ascii),
		.key_pressed(key_pressed),
		.ctrl(ctrl),
		.shift(shift),
		.read(read_key)
	);
	
	vga_controller vga_ctrl(
		.CLK_28M(CLK_28M),
		.VIDEO(video_data),
		.COLOR_LINE(color_line),
		.HBL(HBL),
		.VBL(VBL),
		.LD194(ld194),
		.VGA_CLK(VGA_CLK),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK(VGA_BLANK),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B)
	);
	assign VGA_SYNC = 1'b0;
	
	CLK28MPLL clk28(
		.inclk0(Clock_50Mhz),
		.c0(CLK_28M),
		.c1(Clock_14Mhz)
	);
	
	disk_ii disk_controller(
		.Clock_14MHz(Clock_14Mhz),
		.Clock_2MHz(q3),
		.pre_phase0(pre_phase0),
		.io_select(io_select[6]),
		.device_select(device_select[6]),
		.reset(Reset_h),
		.ram_write_addr(track_ram_addr),
		.ram_di(track_ram_di),
		.ram_we(track_ram_we),
		.addr(cpu_addr),
		.disk_ii_data_in(cpu_data_out),
		.disk_ii_data_out(peripheral_out),
		.track(track),
		.track_addr(track_addr),
		.disk1_on(disk1_on),
		.disk2_on(disk2_on),
		.motor_phase(motor_phase)
	);
	
	//intermidate signals
	logic [3:0] motor_phase;
	logic [5:0] track;
	logic [13:0] track_ram_addr, track_ram_di, track_ram_we, track_addr;
	logic disk1_on, disk2_on;

	spi_controller sdcard(
		.CLK_14M(Clock_14Mhz),
		.RESET(Reset_h),
		.CS_N(SD_DAT3),
		.MOSI(SD_CMD),
		.MISO(SD_DAT0),
		.SCLK(SD_CLK),
		.track(track),
		.image(SW[9:0]),
		.ram_write_addr(track_ram_addr),
		.ram_di(track_ram_di),
		.ram_we(track_ram_we)
	);
	
	//might be broken because it is always 1
	assign LEDR[0] = disk1_on;
	assign LEDR[1] = disk2_on;
	assign LEDR[2] = io_select[6];
	assign LEDR[3] = device_select[6];
	//assign LEDR = motor_phase;
	
	//PC on HEX3-0
	HexDriver hex_driver0(cpu_addr[3:0], HEX0);
	HexDriver hex_driver1(cpu_addr[7:4], HEX1);
	HexDriver hex_driver2(cpu_addr[11:8], HEX2);
	HexDriver hex_driver3(cpu_addr[15:12], HEX3);
	
	//track on HEX5/4
	HexDriver hex_driver4(SW[3:0], HEX4);
	HexDriver hex_driver5(SW[7:4], HEX5);
	
	//image on Hex6/7
	HexDriver hex_driver6(peripheral_out[3:0], HEX6);
   HexDriver hex_driver7 (peripheral_out[7:4], HEX7);
	
	
	
	//assign LEDG = ascii;
	assign LEDG = peripheral_out;
endmodule

