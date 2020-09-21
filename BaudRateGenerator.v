module BaudRateGenerator(
    input Clk, Reset,
	 input [31:0] BaudRate,
    output Tick
);

	reg [31:0] Counter; // Contador
	wire [31:0] Rate; // Divisor para BaudRate

	BaudRateDivisor BRD(.HzClock(32'd50000000), .BaudRate(BaudRate), .Rate(Rate));

	always @(posedge Clk or negedge Reset)
	begin
		if (!Reset)
		begin
			Counter <= 32'd1;
		end
		else if (Tick)
		begin
			Counter <= 32'd1;
		end
		else Counter <= Counter + 32'd1;
	end
	
	assign Tick = (Counter == Rate);
	
endmodule

module BaudRateDivisor(
	input [31:0] HzClock, BaudRate,
	output wire [31:0] Rate
);
	// Valor para dividir o Gerador
	assign Rate = HzClock / (16 * BaudRate);

endmodule
