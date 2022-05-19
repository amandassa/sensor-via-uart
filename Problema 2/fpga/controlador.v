module controlador (
    output [0:7] out_dados_8,
    output o_sensor_en,
    output o_sensor_rst,
    output o_start_tx,
	input wire [0:7] in_endereco_8,
	input wire [0:7] in_solicitacao_8,
	input wire [7:0] HUM_INT,
	input wire [7:0] TEMP_INT,
	input wire [7:0] CRC,
	input clock
);

    reg [7:0] STATUS = 3;
    reg [7:0] TEMP = 4;
    reg [7:0] HUM = 5;

	reg [0:7] aux_dados; 
	reg [0:7] aux_float;
	reg [0:26] count;
	reg CRC_SUM;

    wire sensor_en, sensor_rst, tx_start;
	
    assign o_sensor_en = sensor_en;

    // divisor de clock
	always @ (posedge clock) begin 
		if (count == 26'h3FFFFFF) begin 
			count = 26'b00000000000000000000000000;    // 1 segundo
		end
		count <= count + 1'b1;
	end

    always @ (posedge in_solicitacao_8) begin
        case (in_solicitacao_8)
        STATUS: begin		// status do sensor
            CRC_SUM = (HUM_INT + HUM_FLOAT + TEMP_INT + TEMP_FLOAT);
            if (CRC_SUM == CRC) begin
                aux_dados = 0;
            end 
            else begin
                aux_dados = 31;
            end
        end
        TEMP: begin 		// temperatura
            aux_dados = TEMP_INT;
        end
        HUM: begin        // umidade
            aux_dados = HUM_INT;
        end
        tx_start = 1'b1;
        endcase
    end
    assign o_start_tx = tx_start;
	assign dados_out8 = aux_dados;

endmodule 