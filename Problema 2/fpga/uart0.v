/* TOP LEVEL  */
module uart0(out, in, clk_50mhz, reset, DHT_DATA, error_dht11);
		 
input in, clk_50mhz, reset; // entrada do receptor, clock e sinal de reset
output out; 				// pino de saída do transmissor conectado a raspberry			
inout DHT_DATA;				// pino da via única de dados do dht11 com a fpga
output error_dht11;			// pino de que indica erro na comunicação do sensor


wire clk_115200hz;   // fio que levará o clock aos módulos transmitter, decodificador e receiver
baudrate_gen   		// chamada do módulo divisor de clock (gerador de baudrate)
(
	.clk(clk_50mhz),
	.tick(clk_115200hz)
);

wire control_decod;     // fio de controle/enable do decodificador
wire start_tx;			// fio de start/enable transmitter
wire [7:0] out_receiver;// barramento de 8 bits para trafegar os dados recebidos
receiver receiver_0(    //módulo receptor
	.clk_115200hz(clk_115200hz),
	.in(in),
	.data(out_receiver),		// 
	.control(control_decod)
);
wire wait_dht11; // fio do sinal de espera do dht11
wire start_dht11; // fio de enable/start do dht11
wire [0:39] dados_sensor; // barramento de 40 bits do sensor dht11

decodificador decod( // módulo decodificador
	.out_dados_8(in_transmitter),
	.in_solicitacao_8(out_receiver),
	.clock(clk_115200hz),
	.start(start_tx),
	.control(control_decod),
	.wait_dht11(wait_dht11),
	.start_dht11(start_dht11),
	.sensor_data(dados_sensor)
	);
	
dht11 sensor( // módulo do sensor dht11
	 .i_Clock(clk_50mhz),  //50 MHz 
    .i_En(start_dht11), 
    .i_Dht_Data(DHT_DATA),
	 .sensor_data(dados_sensor),
	 .o_Wait(wait_dht11),
	 .o_Error(error_dht11)
    );
	
wire [0:7] in_transmitter; // barramento de 8 bits para trafegar os dados recebidos para o decodificador

transmitter transmitter_0( // módulo transmissor
	.clk_115200hz(clk_115200hz),
	.out(out),
	.data(in_transmitter),
	.start(start_tx),
);


endmodule 
