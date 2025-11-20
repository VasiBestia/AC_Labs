`timescale 1ns/1ps

module UAL(
  output reg [4:0]sum,
  output reg [7:0]mult,
  input [3:0]a,
  input [3:0]b,
  input op
    );
    always @* begin
    sum=0;
    mult=1;
     if(op==1)begin 
      sum=a+b;
      mult=1;
     end else if(op==0) begin
      mult=a*b;
      sum=0;
     end
     end
endmodule