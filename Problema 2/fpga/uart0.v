module uart0(out, in, clk_50mhz, aux_led, reset, wait_out, d, DHT_DATA);
		 
input in, clk_50mhz, reset;
output aux_led;
output out;
output wait_out;
output DHT_DATA;
output [7:0] d;

//Provisorio pra testes
//output [0:7]data;

wire [0:7]data_in;
wire [0:7]data_out;

wire clk_115200hz;
baudrate_gen  
(
	.clk(clk_50mhz),
	.tick(clk_115200hz)
);

wire start;
wire out_receiver;
wire [7:0] meu_deus;
receiver receiver_0(
	.clk_115200hz(clk_115200hz),
	.in(in),
	.reset(reset),
	.data(meu_deus),		// 
	.aux_led(aux_led)
);

decodificador decod0(
	.out_dados_8(paratx),
	.in_solicitacao_8(meu_deus),
	.clock(clk_115200hz),
	.start(start)
	);

wire [7:0] paratx;

transmitter transmitter_0(
	.clk_115200hz(clk_115200hz),
	.out(out),
	.reset(reset),
	.data(paratx),
	.start(start),
	.led2(wait_out)
	//.tx(d)
);


endmodule 
