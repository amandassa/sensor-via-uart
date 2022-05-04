module baudrate_gen (input clk, output BaudTick);
	parameter ClkFrequency = 25000000;			// clk da fpga
	parameter Baud = 115200;						// taxa de baud	
	parameter BaudGeneratorAccWidth = 16;		// nº de regs necessarios para o divisor desejado (25)
	parameter BaudGeneratorInc = ((Baud<<(BaudGeneratorAccWidth-4))+(ClkFrequency>>5))/(ClkFrequency>>4);
	
	reg [BaudGeneratorAccWidth:0] BaudGeneratorAcc;
	reg [1:0] bdtk;
	assign BaudTick = bdtk;
	
	always @(posedge clk)	begin
		BaudGeneratorAcc <= BaudGeneratorAcc[BaudGeneratorAccWidth-1:0] + BaudGeneratorInc;
		bdtk = BaudGeneratorAcc[BaudGeneratorAccWidth];
	end
endmodule 
