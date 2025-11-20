`timescale 1ns/1ps

module testbench();
  reg clk;
  reg rst;
  reg valoare;
  wire out;
  automatfinit main(
  .clk(clk),
  .rst(rst),
  .valoare(valoare),
  .out(out)
  );
  parameter T_clk=10;
  initial begin
  clk=0;
  forever #(T_clk) clk=~clk;
  end
  initial begin

   $dumpfile("automatfinit_tb.vcd");
   $dumpvars(0,testbench);
  rst=1;
  valoare=0;
  #(2*T_clk)rst=0;
  valoare=0;
  #(5*T_clk);
  valoare=1;
  #(5*T_clk);
  valoare=1;
  #(5*T_clk);
  valoare=0;
  #(5*T_clk);
  end
endmodule