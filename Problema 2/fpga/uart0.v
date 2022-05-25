module uart0(out, in, clk_50mhz, aux_led, led_control, reset, wait_out, d, DHT_DATA, error_dht11);
		 
input in, clk_50mhz, reset;
output aux_led;
output out;
output wait_out;
inout DHT_DATA;
output [7:0] d;
output led_control;
output error_dht11;

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

wire control_decod;
wire start_tx;
wire [7:0] out_receiver;
receiver receiver_0(
	.clk_115200hz(clk_115200hz),
	.in(in),
	.data(out_receiver),		// 
	.aux_led(aux_led),
	.control(control_decod)
);
wire wait_dht11;
wire start_dht11;
wire [0:39] dados_sensor;

decodificador decod(
	.out_dados_8(in_transmitter),
	.in_solicitacao_8(out_receiver),
	.clock(clk_115200hz),
	.start(start_tx),
	.control(control_decod),
	.wait_dht11(wait_dht11),
	.start_dht11(start_dht11),
	.sensor_data(dados_sensor)
	);
	
dht11 sensor(
	 .i_Clock(clk_50mhz),  //50 MHz
    .i_En(start_dht11), 
    .i_Dht_Data(DHT_DATA),
	 .sensor_data(dados_sensor),
	 .o_Wait(wait_dht11),
	 .o_Error(error_dht11),
	 .ledPrint(led_control)
    );
	
wire [0:7] in_transmitter;

transmitter transmitter_0(
	.clk_115200hz(clk_115200hz),
	.out(out),
	.data(in_transmitter),
	.start(start_tx),
	.led2(wait_out)
	//.tx(d)
);


endmodule 
