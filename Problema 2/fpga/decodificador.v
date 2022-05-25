module decodificador (
	output [0:7] out_dados_8,
	input wire [0:7] in_endereco_8,
	input wire [7:0] in_solicitacao_8,
	input wire [0:39] sensor_data,	
	input clock,
	input control,
	input wait_dht11,
	output reg start,
	output reg start_dht11
	);
	
	
	reg [7:0] aux_dados; 
	reg [0:7] aux_float;
	reg [0:26] count;
	reg CRC_SUM;
	reg [1:0] state;
		parameter START = 0,
					 WAIT_DHT11 = 1,
					 DATA = 2,
					 STOP = 3;		
	

	
always @ (posedge clock) begin
	case (state)
		START: begin
			start = 1'b0; // enable tx = 0	
			if(control) begin
			   start_dht11 <= 1'b1;
				start <= 1'b0; // enable tx = 0	
				state <= WAIT_DHT11;				 
			 end else begin 
				 start = 1'b0; // enable tx = 0				 
				 state <= START;
			 end
		end
		
		WAIT_DHT11: begin
				if(wait_dht11 == 1) begin
					state <= WAIT_DHT11;
				end else begin				   
					state <= DATA;				
				end
			
		end	
		
			 
		DATA: begin
			if(in_solicitacao_8 == 8'b00000011) begin	// se solicitação == 3 
				if(sensor_data[32:39] == (sensor_data[0:7] + sensor_data[8:15] + sensor_data[16:23] + sensor_data[23:31]))begin
						aux_dados = 8'b00000000;  // SENSOR OK
					end else begin aux_dados = 8'b00000110;
						aux_dados = 8'b00011111; // SENSOR COM PROBLEMA
				end
				start = 1'b0;
				state <= STOP;
			end 	
			else if(in_solicitacao_8 == 8'b00000100)begin // se solicitação == 4
				
				aux_dados = sensor_data[16:23];  // Temperatura INT// 
				start = 1'b0;
				state <= STOP;
			end
			else if(in_solicitacao_8 == 8'b00000101)begin // se solicitação == 5 
			   aux_dados = sensor_data[0:7]; // Umidade INT sensor_data[0:7]
				start = 1'b0;
				state <= STOP;
			end else begin                                // se não foi nenhum dos 3
				aux_dados = 8'b00000000; // devolvo 0
			   start = 1'b0;	
				state <= STOP;		
			end
		end
		STOP: begin
			start_dht11 = 1'b0; // disable dht11
			start <= 1'b1;  // enable tx
			state <= START;		
		end
	
	endcase
end

assign out_dados_8 = aux_dados;
	
endmodule 