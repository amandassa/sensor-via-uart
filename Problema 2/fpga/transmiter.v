module transmitter(clk_115200hz, out, data, start, led2, tx);

input clk_115200hz, start;
input [0:7]data;
output out;
output reg led2 = 1;
output [0:7] tx;

reg reset = 0;

assign tx = data;

reg out = 1'b1;
reg [1:0]state;
	parameter START=0,
				 DATA=1,
				 STOP=2;
					
integer counter = 7;

always @ (posedge clk_115200hz or posedge reset) begin
	if (reset == 1) begin
		reset = 0;
		state <= START;		//
	end else begin
		case(state)
			START:
				begin
					if(start) begin
						out = 1'b0;
						state <= DATA;
					end
					else begin
						out = 1'b1;
						state <= START;
					end
				end
			DATA:
				begin
					if (counter < 0) begin
						out = 1'b1;
						state <= STOP;
					end
					else begin
						out = data[counter];
						counter = counter - 1;
						state <= DATA;
					end
				end
			STOP:
				begin
					led2 = 1'b0;	
					counter = 7;
					reset = 1'b1;		//
					state <= START;
				end
		endcase
	end
end

endmodule 