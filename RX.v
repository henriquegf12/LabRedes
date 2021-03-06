module RX(clock, tick, opcode, bitRx, dadoASerEscritoNoBanco, rxFim);

input clock, tick, bitRx; //considerando um baudrate de 115200, cada pulso dura 542ns
input [5:0] opcode;

output reg rxFim;									//sinal para a UC "despausar" o PC
output reg [7:0] dadoASerEscritoNoBanco;	//dadoRx de 8 bits que vai ser escrito no banco de registradores
reg [7:0] dadoLido;	//Register where we store the Rx input bits before assigning it to the RxData output

wire [3:0] NBits;
assign NBits = 4'b1000;	//envio e recebimento de 8 bits
reg startBit;


reg [3:0] contadorTicks = 4'b0000;		//contador de ticks para gravar o bit no meio (primeito conta até 8 e depois vai de 16 a 16)
reg[4:0] bitAtual = 5'b00000;				//usado para contar os bits que já foram lidos


always @ (posedge tick)
	begin
	
			if(opcode == 32'd40) 		//instrucao receive
			begin
				rxFim = 1'b0; 	//sinal para a UC manter o PC pausado
				contadorTicks = contadorTicks + 4'd1;
				
				if((contadorTicks == 4'b1000) & (startBit == 0))	//se está no meio do bit de start
				begin
					startBit = 0;	//pois os proximos bits serao do conteudo da mensagem
					contadorTicks = 0;	//a partir daqui ele conta de 16 em 16 para ler os bits do conteudo da mensagem
				end
				
				if((contadorTicks == 4'b1111) & (startBit = 1) & (bitAtual < NBits))
				begin
					bitAtual = bitAtual+5'd1;
					
					/*na UART, quem chega primeiro é o bit MENOS significativo*/
					dadoLido <= {bitRx, dadoLido[7:1]}; //concatenação
							
					contadorTicks = 4'b0000;
				end
				
				if((contadorTicks == 4'b1111) & (bitAtual == NBits) & (bitRx == 1)) //rx igual a zero significa bit de stop
				begin
					bitAtual = 4'b0000;
					rxFim = 1'b1; 
					contadorTicks = 4'b0000;
					startBit = 1'b1;
				
				end
			end	
	
	end
	
	always @ (posedge clock)
	begin
		if (NBits == 4'b1000)
		begin
			dadoASerEscritoNoBanco <= dadoLido;	
		end
	end
endmodule
