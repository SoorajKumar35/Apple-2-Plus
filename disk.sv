module disk_ii (
	input logic Clock_14MHz,
					Clock_2MHz,
					pre_phase0,
					io_select,
					device_select,
					reset,
	input logic [13:0] ram_write_addr,
	input logic [7:0] ram_di,
	input logic ram_we,
	input logic [15:0] addr,
	input logic [7:0] disk_ii_data_in,
	output logic [7:0] disk_ii_data_out,
	output logic [5:0] track,
	output logic [13:0] track_addr,
	output logic	disk1_on,
						disk2_on,
	output logic [3:0] motor_phase
);

	//control signals
	logic [7:0] head_half_phase, phase_l; //phase
	logic disk_on, disk2_select;
	
	//disk ii rom signals
	logic [7:0] rom_out; //rom_dout
	
	//track ram signals
	logic [13:0] ram_read_addr;
	logic [7:0] ram_out;
	assign ram_read_addr = track_byte_addr[14:1];
	dual_port_ram track_ram(
		.data(ram_di),
		.read_addr(ram_read_addr),
		.write_addr(ram_write_addr),
		.we(ram_we),
		.clk(Clock_14MHz),
		.q(ram_out)
	);
	
	//disk signals
	logic [14:0] track_byte_addr;
	logic read_disk;
	
	
	//disk control
	always_ff @(posedge Clock_2MHz) begin
		if(reset) begin
			motor_phase <= 4'd0;
			disk_on <= 1'b0;
			disk2_select <= 1'b0;
		end
		else if(pre_phase0 && device_select) begin
			if(~addr[3])
				motor_phase[addr[2:1]] <= addr[0];
			else begin
				case(addr[2:1])
					2'b00: disk_on <= addr[0];
					2'b01: disk2_select <= addr[0];
					default:;
				endcase
			end
		end
	end
	
	assign disk1_on = disk_on & ~disk2_select;
	assign disk2_on = disk_on & disk2_select;
	
	
	//phase control
	//There might be issues with signed values
	integer phase_change;
	integer new_phase;
	logic [3:0] rel_phase;
	
//	always_comb begin
	always_ff @(posedge Clock_14MHz) begin
		phase_change = 0;
		new_phase = head_half_phase;
		rel_phase = motor_phase;
		case(head_half_phase[2:1])
			2'b00: rel_phase = {rel_phase[1:0], rel_phase[3:2]};
			2'b01: rel_phase = {rel_phase[2:0], rel_phase[3]};
			2'b10: ;
			2'b11: rel_phase = {rel_phase[0], rel_phase[3:1]};
		endcase
		if(head_half_phase[0]) begin//odd phase
			case(rel_phase)
				4'b0000: phase_change = 0;
				4'b0001: phase_change = -3;
				4'b0010: phase_change = -1;
				4'b0011: phase_change = -2;
				4'b0100: phase_change = 1;
				4'b0101: phase_change = -1;
				4'b0110: phase_change = 0;
				4'b0111: phase_change = -1;
				4'b1000: phase_change = 3;
				4'b1001: phase_change = 0;
				4'b1010: phase_change = 1;
				4'b1011: phase_change = -3;
				4'b1100: ;
				4'b1101: ;
				4'b1110: ;
				4'b1111: phase_change = 0;
			endcase
		end
		else begin
			case(rel_phase)
				4'b0000: phase_change = 0;
				4'b0001: phase_change = -2;
				4'b0010: phase_change = 0;
				4'b0011: phase_change = -1;
				4'b0100: phase_change = 2;
				4'b0101: phase_change = 0;
				4'b0110: phase_change = 1;
				4'b0111: phase_change = 0;
				4'b1000: phase_change = 0;
				4'b1001: phase_change = 1;
				4'b1010: phase_change = 2;
				4'b1011: phase_change = -2;
				4'b1100: ;
				4'b1101: ;
				4'b1110: ;
				4'b1111: phase_change = 0;
			endcase
		end
		
		if(new_phase + phase_change <= 0)
			new_phase = 0;
		else if(new_phase + phase_change > 139)
			new_phase = 139;
		else
			new_phase = new_phase + phase_change;
		
		head_half_phase = new_phase;
	end
		
//	always_ff @(posedge Clock_14MHz) begin
//		phase_l <= head_half_phase;
//	end
	
	assign track = head_half_phase[7:2];
	
	//track addressing logic
	logic [5:0] byte_delay;
	always_ff @(posedge Clock_2MHz) begin
		if(reset) begin
			track_byte_addr <= 15'd0;
			byte_delay = 6'd0;
		end
		else begin
			byte_delay = byte_delay - 1;
			if((read_disk && pre_phase0) || byte_delay == 6'd0) begin
				byte_delay = 6'd0;
				if(track_byte_addr == 15'h33fe) 
					track_byte_addr <= 15'd0;
				else
					track_byte_addr <= track_byte_addr + 15'd1;
			end
		end
	end
	
	disk_rom rom(
		.addr(addr[7:0]),
		.clk(Clock_14MHz),
		.q(rom_out)
	);
	
	assign read_disk = (device_select && addr[3:0] == 4'hC)?1'b1:1'b0;
	assign disk_ii_data_out = 	(io_select)?rom_out:
										(read_disk && ~track_byte_addr[0])?ram_out:
										8'd0;
	assign track_addr = track_byte_addr[14:1];
	
	
endmodule
