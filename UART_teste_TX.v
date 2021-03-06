module UART_teste_TX(input Clk,
							input [5:0] Opcode,
							input [7:0] Data_send,	
							output wire Tx,tick,
							output wire TxDone //dadoRx de 8 bits que vai ser escrito no banco de registradores
);
	parameter BaudRate = 32'd115200;
	wire Rst_n;
	

	TX Transmitter(.Clk(Clk), .tick(tick),.opcode(Opcode),.Data(Data_send),.TxDone(TxDone),.Tx(Tx));
	BaudRateGenerator BDG(.Clk(Clk), .Reset(1), .BaudRate(BaudRate), .Tick(tick));
								
endmodule

