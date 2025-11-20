`timescale 1ns / 1ps

module sumatornbiti(
  output [Width:0]sum,
  input [Width-1:0]a,
  input [Width-1:0]b
    );
    parameter Width=8;
    assign sum=a+b;
endmodule