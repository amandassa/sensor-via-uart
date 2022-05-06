module uart0 (
	output reg [7:0] dados_saida,
	output data_ready,
	input clk);
	
	reg [7:0] RxD_data = 1'b010010;
	
	async_receiver #(50000000, 115200, 8) RxD(.clk(clk), .RxD(dados_saida), .RxD_data_ready(data_ready));
endmodule
