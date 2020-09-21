module UART(input Clk, bitRx,
				input [5:0] Opcode,
				input [7:0] Data_send,	
				output wire rxFim, tick,
				output wire [7:0] Data_Write //dadoRx de 8 bits que vai ser escrito no banco de registradores
);
	parameter BaudRate = 32'd115200;
	wire Rst_n;
	
	RX Receiver(.clock(Clk), .tick(tick), .opcode(Opcode), .bitRx(bitRx), .dadoASerEscritoNoBanco(Data_Write), .rxFim(rxFim));
	//TX Transmitter(Clk, TxEn, TxData, TxDone, Tx, Tick, NBits);
	BaudRateGenerator BDG(.Clk(Clk), .Reset(1), .BaudRate(BaudRate), .Tick(tick));
								
endmodule
