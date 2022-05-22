module receiver(clk_115200hz, in, reset, data, aux_led, control, d);

input clk_115200hz, in, reset;
output control;
reg control = 1'b0;
output reg aux_led = 1'b0;
output reg [7:0] d;
output [7:0]data;
reg [7:0]data;	
reg [7:0]buffer;
reg [1:0]state;
	parameter START = 0, 
				 DATA = 1,
				 STOP = 2;			 

integer counter = 0;		

always @ (posedge clk_115200hz or posedge reset) begin
if (reset)
state <= START;
else
case (state)
	START:
		begin
			if(in) begin
			   control = 1'b0;
				state <= START;
			end
			else				
				state <= DATA;
		end
	DATA:
		begin
			if(counter > 7)
				state <= STOP;
			else begin			
				buffer[counter] = in;
				d[counter] = buffer[counter];
				counter = counter + 1;				
				state <= DATA;
			end	
		end
	STOP:
		begin
			data[7:0] = buffer [7:0];
			counter = 0;
			aux_led = 1'b1;
			control = 1'b1;
			state <= START;
			
		end
endcase
end
endmodule
