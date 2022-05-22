module baudrate_gen(clk, tick);

input clk; 
output reg tick; 
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd434;
// clock  50Mhz/115200 = 434 

always @(posedge clk)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;

 tick <= (counter<DIVISOR/2)?1'b1:1'b0;

end
endmodule