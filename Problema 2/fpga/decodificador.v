module decodificador (
	output [7:0] out_dados_8,
	input wire [0:7] in_endereco_8,
	input wire [7:0] in_solicitacao_8,
	input wire [7:0] HUM_INT,
	input wire [7:0] HUM_FLOAT,
	input wire [7:0] TEMP_INT,
	input wire [7:0] TEMP_FLOAT,
	input wire [7:0] CRC,
	input clock,
	output reg start
	);
	
	reg [0:7] aux_dados; 
	reg [0:7] aux_float;
	reg [0:26] count;
	reg CRC_SUM;
	

	
	always @ (posedge clock) begin
		start = 1'b0;
		case (in_solicitacao_8)
		8'b00000011:	// status do sensor
			begin
				aux_dados = 8'b00000011;
				start = 1'b1;
			
		
		end
		8'b00000100: begin 		// temperatura
			aux_dados = 8'b00000100;
			start = 1'b1;
		end
		8'b00000101: begin 
			aux_dados = 8'b00000101;
			start = 1'b1;
		end
		endcase
	end

	assign out_dados_8 = aux_dados;
	
endmodule 