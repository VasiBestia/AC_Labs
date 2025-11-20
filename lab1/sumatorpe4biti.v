`timescale 1ns / 1ps

module sumator(
  output [5:0]sum,
  input [3:0]a,
  input [3:0]b
    );
    assign sum=a+b;
endmodule
