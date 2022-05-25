`timescale 1ns / 1ps

module dht11(
	input i_Clock,  //50 MHz
    input i_En,
    input i_Rst,	 
    inout i_Dht_Data,
	output [0:39] sensor_data,
	output o_Wait,
	output o_Error,
	output ledPrint
    );

	reg led_print = 1'b1;
	reg DHT_OUT, DIR, WAIT_REG;  //Registrador de saida	
	reg [25:0] COUNTER; //Contador de ciclos para gerar delays
	reg [5:0] index;
	reg [0:39] INTDATA; //registrador de dados interno
	reg error_REG;
	wire [0:39] DHT_IN;
	//reg [4:0] colunat = 5'b00000;
	//wire DHT_IN;
	assign ledPrint = error_REG;
	assign o_Wait = WAIT_REG;
	assign o_Error = error_REG;
	assign sensor_data = INTDATA;
	//assign i_Dht_Data = DIR ? DHT_OUT : 1'bZ; // Se DIR 1 -- copia DHT_OUT para saida, caso nao, deixa o pino indefinido para atuar como entrada
	//assign DHT_IN = i_Dht_Data;


TRIS tristate(
    .i_Port(i_Dht_Data),
    .i_Dir(DIR),
    .i_Send(DHT_OUT),
    .o_Read(DHT_IN)
    );


	 reg [3:0] STATE;
	 
	 //Definição de estados
	 parameter S0=1, S1=2, S2=3, S3=4, S4=5, S5=6, S6=7, S7=8, S8=9, S9=10, STOP=11, START=0;

 
	//Processo de FSM 
	always @(posedge i_Clock)
	begin: FSM
	  if (i_En == 1'b1)
	  
	  begin
		 if ( i_Rst == 1'b1)
		 begin
			  DHT_OUT <= 1'b1;			  
			  WAIT_REG <= 1'b0;
			  COUNTER <= 26'b00000000000000000000000000;	
			  INTDATA <= 40'b0000000000000000000000000000000000000000;
			  DIR <= 1'b1;			   //Configura pino saida
			  error_REG <= 1'b0;
			  STATE <= START;
		 end else begin
		 
			 case (STATE)
				 START:
				     begin
							
						   WAIT_REG <= 1'b1;
							error_REG <= 1'b0;
							DIR <= 1'b1;
							DHT_OUT <= 1'b1;	
							STATE <= S0;							 
					  end
			   
				 S0:
					 begin
					   DIR <= 1'b1;	
					   DHT_OUT <= 1'b1;
						WAIT_REG <= 1'b1;
						error_REG <= 1'b0;
						if (COUNTER < 900000)							// -- b111001111110111100000 --100.000.000/2 = 50.000.000 -> 1/50.000.000 = 0,00002ms --> 18ms/0,00002 = 900000 ciclos)
						begin
							COUNTER <= COUNTER +1'b1;
						end else begin
							COUNTER <= 26'b00000000000000000000000000;
							STATE <= S1;
						end
					 end
				 
				 S1:
					 begin
					   DHT_OUT <= 1'b0;	
						WAIT_REG <= 1'b1;
						if (COUNTER < 900000)							// --b111001111110111100000 -- 100.000.000/2 = 50.000.000 -> 1/50.000.000 = 0,00000002s --> 18ms/0,00002 = 900000 ciclos)
						begin
							COUNTER <= COUNTER +1'b1;
						end else begin
							COUNTER <= 26'b00000000000000000000000000;
							STATE <= S2;
						end
					 end
				S2:
					begin					   
						DHT_OUT <= 1'b1;			//Leva para 1 aguarda 20 uS (resposta do DHT ocorre entre 20 e 40 uS)						
						if (COUNTER < 1000)
						begin
						   COUNTER <= COUNTER +1'b1;
						end else begin						
							DIR <= 1'b0;							
							STATE <= S3;									
						end						
					end
					
				S3:
					begin	 
               //   DIR <= 1'b0;					
						if (COUNTER < 3000 && DHT_IN == 1'b1 )							// 60 (88) uS / 0,02uS = 2000 CICLOS DE 50MHZ
						begin		                     						
						 	COUNTER <= COUNTER +1'b1;
							STATE <= S3;
						end else begin
						  if ( DHT_IN == 1'b1 )  											//Se ultrapassa o limite de 40uS -- erro de inicializacao do DHT11
						  begin						  																	
							   error_REG <= 1'b1;
								COUNTER <= 26'b00000000000000000000000000;
							   STATE <=STOP;
						  end else begin
						      COUNTER <= 26'b00000000000000000000000000;
						      STATE <=S4;														//Nao passou 40uS, entao DHT foi a 0, logo - OK
						  end
						end
					end
					
				S4:
					begin
					  //DETECTA PULSO DE SINCRONISMO - P1
						if ( DHT_IN == 1'b0  && COUNTER < 4400)												// 0,00002 = 0,02 uS -> 80uS/0,02uS = 10000 ciclos de 50MHz -> 25'b0000000000000111110100000
						begin
						   COUNTER <= COUNTER +1'b1;
							STATE <= S4;
						end else begin
					      if ( DHT_IN == 1'b0)
							begin
							   error_REG <= 1'b1;
								COUNTER <= 26'b00000000000000000000000000;	
							   STATE <=STOP;
							end else begin 
						   	STATE <= S5;
								COUNTER <= 26'b00000000000000000000000000;															
							end
						end
					end
			
				S5:
					begin
					  //DETECTA PULSO DE SINCRONISMO - P2
						if ( DHT_IN == 1'b1 && COUNTER < 4400)												// 0,00002 = 0,02 uS -> 80uS/0,02uS = 10000 ciclos de 50MHz -> 25'b0000000000000111110100000
						begin
						   COUNTER <= COUNTER +1'b1;
							STATE <= S5;
						end else begin
						   if ( DHT_IN == 1'b1)
							begin
							   error_REG <= 1'b1;
								COUNTER <= 26'b00000000000000000000000000;	
							   STATE <=STOP;
							end else begin 
								STATE <= S6;  
								error_REG <= 1'b0;
								index <= 6'b000000; //reseta indexador
								COUNTER <= 26'b00000000000000000000000000;															
							end
						end
					end
				//Inicio da analise de dados	
				S6:						//Realiza Resets
					begin				
							 if ( DHT_IN == 1'b0 )
							 begin
								STATE <= S7;
							end else begin
							   error_REG <= 1'b1;
								COUNTER <= 26'b00000000000000000000000000;	
							   STATE <=STOP;							
							end
					end					
				
				S7:      //Chegou neste estado, o nivel logico jï¿½ ï¿½ zero, deve aguardar comutaï¿½ï¿½o para 1 de modo a avaliar tempos
					begin
					  if ( DHT_IN == 1'b1 )
					  begin
								COUNTER <= 26'b00000000000000000000000000;
								STATE <= S8;								
						end else begin
						   if ( COUNTER < 16000000)  // -- 60uS - 3000 ciclos - VERIFICA SE ESTOUROU TEMPO PARA IR A ZERO E INICIAR TRANSMISSAO DE DADOS
							begin								
								COUNTER <= COUNTER +1'b1;
								STATE <= S7;	
							end else begin
								COUNTER <=  26'b00000000000000000000000000;
								error_REG <= 1'b1;
								STATE <= STOP;
							end
						end
					end
					
				S8:   //Aguarda comutaï¿½ï¿½o para 0
				   begin
						if (  DHT_IN == 1'b0 ) /// 50MHz = 0,02 uS -> 60uS = 2500 ciclos
						begin
									
									if ( COUNTER > 2500) 
									begin
									   INTDATA[index] <= 1'b1;
										
									end else begin
		
										INTDATA[index] <= 1'b0;								   
									end																	

									if (index < 39 )
									begin										
										COUNTER <= 26'b00000000000000000000000000;
										STATE <= S9;
									end else begin		
										error_REG <= 1'b0;									
										STATE <= STOP;
									end										
									
									
								//	STATE <= S9;
									
						end else begin
									COUNTER <= COUNTER + 1'b1;
									
									if (COUNTER > 16000000) //Caso mais de 32mS de espera, aborta
									begin
									   error_REG <= 1'b1;
										STATE <= STOP;
									end
						end
					 end
					 
				 S9:
					begin
					    index <= index+1'b1;
						 STATE <= S6;
					end	
				 
				 STOP:
					begin
					//STATE <= STOP;
					   if ( error_REG == 1'b0 ) 
						begin
						   //led_print = 1'b1;						
							DHT_OUT <= 1'b1;								
							WAIT_REG <= 1'b0;
							COUNTER <= 26'b00000000000000000000000000;	
							DIR <= 1'b1;			   //Configura pino saida	
							error_REG <= 1'b0;							
							index <= 6'b000000;
							//STATE <= START;
						end else begin
							INTDATA <= 40'b0000000000000000000000000000000000000000;
							error_REG <= 1'b1;
							WAIT_REG <= 1'b0;
							DIR <= 1'b1;			   //Configura pino said
							error_REG <= 1'b0;				//volta error_REG a 0 para resetar tudo
							//STATE <= START;		///////////////
						end
					//STATE <= START;
					end
			 endcase
		end // end else reset
	end // and if(enable)
  end // end always


endmodule
