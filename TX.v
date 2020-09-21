module TX(Clk,tick,opcode,Data,TxDone,Tx);

input Clk,tick;
input [5:0] opcode;
input [7:0] Data;

output reg Tx;
output reg TxDone;


wire [3:0] NBits;
assign NBits = 4'b1000;	//envio e recebimento de 8 bits

reg startBit = 1'b1;
reg stopBit = 1'b0;
reg [3:0] contadorTicks = 4'b0000;
reg [7:0] Txdata=8'b00000000;
reg[4:0] bitAtual = 5'b00000;		

always @ (posedge tick)
begin
	if(opcode != 32'd41) //reseta parametros
	begin
		startBit = 1'b1;
		stopBit = 1'b0;
		Tx = 1'b1;
		contadorTicks =4'b0000;
		bitAtual = 5'b00000;
		TxDone= 1'b1;
	end

	if(opcode == 32'd41)
	begin
		
		contadorTicks = contadorTicks + 1'b1;
		
		if(startBit & !stopBit)
		begin
			Tx = 1'b0; // envia o strat bit
			TxDone = 1'b0;
			Txdata = Data; //seta o dado a ser enviado
		end
		
		if ((contadorTicks == 4'b1111) & (startBit) ) // primeiro bit
		begin
			startBit = 1'b0;
			Txdata = {1'b0,Txdata[7:1]};
			Tx = Txdata[0];
			contadorTicks = 4'b0000; 
		end
		
		if ((contadorTicks == 4'b1111) & (!startBit) & (bitAtual < (NBits - 1))) //demais 7 bit
		begin
			Txdata = {1'b0,Txdata[7:1]};
			bitAtual =bitAtual+1;
			Tx = Txdata[0];
			startBit = 1'b0;
			contadorTicks = 4'b0000;
		end
		
		if ((contadorTicks == 4'b1111) & (bitAtual == NBits-1) & (!stopBit))	//finalizando com stop bit
		begin
			Tx = 1'b1;	
			contadorTicks = 4'b0000;	
			stopBit = 1'b1;
		end
		
		if ((contadorTicks == 4'b1111) & (bitAtual == NBits-1) & (stopBit) )	// enviando sinais de final de trasnmissao 
		begin
			bitAtual = 5'b00000;
			TxDone = 1'b1;
			contadorTicks = 4'b0000;
			startBit =1'b1;
			stopBit = 1'b0;
			Tx = 1'b1;
		end
		
	end
end








endmodule