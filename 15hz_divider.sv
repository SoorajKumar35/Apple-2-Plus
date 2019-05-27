module divider_15Hz(
	input logic CLK_50,
	output logic CLK_15Hz
);

logic [24:0] counter;

initial
begin
	counter = 0;
	CLK_15Hz = 0;
end

always_ff @(posedge CLK_50)
begin
	if(counter == 0)
	begin
		counter <= 3333333;
		CLK_15Hz <= ~CLK_15Hz;
	end
	else
	begin
		counter <= counter - 1;
	end
end

endmodule
