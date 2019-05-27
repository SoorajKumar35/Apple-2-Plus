
module flip_flop # (parameter NUM_BITS=1)
						 (input logic Clk,
								   Reset,
								   clear_n,
								   preset_n,
						  input logic [NUM_BITS-1:0] p,
						  output logic [NUM_BITS-1:0] q, q_n
						  );

logic [NUM_BITS-1:0] q_buffer;
	
always_ff @ (posedge Clk)
begin
	
	if (Reset) begin
		q <= {NUM_BITS{1'b0}};
	end
	else begin
		q <= q_buffer;
	end
end

always_comb begin

	q_buffer = q;
	if (~clear_n & ~preset_n)
		q_buffer = {NUM_BITS{1'b0}};
	else if (~clear_n & preset_n)
		q_buffer = {NUM_BITS{1'b0}};
	else if (clear_n & ~preset_n)
		q_buffer = {NUM_BITS{1'b1}};
	else begin
		q_buffer = p;
	end
end

assign q_n = ~q;

endmodule

		
						  
						  