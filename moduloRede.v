module moduloRede(	clock, tick, opcode, bitRx,
								dadoASerEscritoNoBanco, rxFim);

input clock, tick, bitRx; //considerando um baudrate de 115200, cada pulso dura 542ns
input [5:0] opcode;

output reg rxFim;
output reg [7:0] dadoASerEscritoNoBanco;	//dadoRx de 8 bits que vai ser escrito no banco de registradores


endmodule
