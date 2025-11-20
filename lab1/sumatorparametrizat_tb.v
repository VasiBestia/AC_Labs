`timescale 1ns / 1ps

module testbench();
  parameter Width=8;
    reg [Width-1:0]a;
    reg [Width-1:0]b;
    initial begin
   $dumpfile("sumatorparametrizat.vcd");  // Numele fișierului generat
        $dumpvars(0, testbench);


    a=Width-1'b1100;
    b=Width-1'b1111;
    #20 
    a=Width-1'b1110;
    b=Width-1'b1011;
    #20 
    a=Width-1'b1000;
    b=Width-1'b1001;
    $finish;
    end 
     sumatornbiti main(
       .sum(),
       .a(a),
       .b(b)
     ); 
endmodule