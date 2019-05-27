module ram(
	input logic 	CLK_50,
	input logic 	[15:0] address,
	input	logic 	CE_N,
						WE_N,
						OE_N,
	inout wire 	[7:0] data
);

reg [7:0] memory [(1<<16)-1:0];

assign data = (!CE_N && !OE_N) ? memory[address] : {8{1'bZ}};

always @(CE_N or WE_N)
begin
  if (!CE_N && !WE_N)
    memory[address] = data;
end

endmodule
