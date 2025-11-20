`timescale 1ns/1ps

module multiplicator(
  output reg [7:0]mult,
  input [3:0]a,
  input [3:0]b
    );
    integer i;
    always @* begin
    mult=0;
    for(i=0;i<4;i=i+1)begin
    if(b[i]!=0) begin
    mult=mult+(a<<i); 
            end
        end
    end
endmodule