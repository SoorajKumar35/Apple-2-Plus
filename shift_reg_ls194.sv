
module shift_reg_ls194
#(parameter DATA_WIDTH=4)
(input logic Clk,
 input logic [DATA_WIDTH - 1:0]  p,
 input logic clear,
				 SRSI,
				 SLSI,
				 s1,
				 s0,
 output logic [DATA_WIDTH - 1:0]  q);
 
logic [DATA_WIDTH-1:0] q_buffer;

always_ff @ (posedge Clk)
begin
	if (~clear) begin
		q <= 4'b0;
	end
	else begin
		q <= q_buffer;
	end
	
end


always_comb
begin
	if (s1 & s0) begin
		q_buffer = p;
	end
	else if (~s1 & s0) begin
		q_buffer = {q[DATA_WIDTH-2:0], SRSI};
	end
	else if (s1 & ~s0) begin
		q_buffer = {SLSI, q[DATA_WIDTH-1:1]};
	end
	else begin
		q_buffer = q;
	end
end
 
endmodule
