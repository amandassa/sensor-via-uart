module decodificador (
	output [0:7] dados,
	input wire [0:7] endereco,
	input wire [0:7] solicitacao,
	input wire [7:0] HUM_INT,
	input wire [7:0] HUM_FLOAT,
	input wire [7:0] TEMP_INT,
	input wire [7:0] TEMP_FLOAT,
	input wire [7:0] CRC,
	input clock
	);
	
	reg [0:7] aux_dados; 
	reg [0:7] aux_float;
	reg [0:26] count;
	reg CRC_SUM;
	
	
	always @ (posedge clock) begin 
		if (count == 26'h3FFFFFF) begin
			count = 26'b00000000000000000000000000;
		end
		count <= count + 1'b1;
	end
	
	always @ (posedge clock) begin
		case (solicitacao)
		3: begin		// status do sensor
			CRC_SUM = (HUM_INT + HUM_FLOAT + TEMP_INT + TEMP_FLOAT);
			if (CRC_SUM == CRC) begin
				aux_dados = 0;
			end 
			else begin
				aux_dados = 31;
			end
		end
		4: begin 		// temperatura
			aux_dados = TEMP_INT;
			aux_float = TEMP_FLOAT;
		end
		5: begin 
			aux_dados = HUM_INT;
			aux_float = HUM_FLOAT;
		end
		endcase
	end
	assign dados = aux_dados;
	
endmodule 