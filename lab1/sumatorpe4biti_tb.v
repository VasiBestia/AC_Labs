`timescale 1ns / 1ps

module testbench();
    reg [3:0]a;
    reg [3:0]b;
    initial begin
    $dumpfile("sumatorpe4biti.vcd");  // Numele fișierului generat
        $dumpvars(0, testbench);

    a=4'b1100;
    b=4'b1111;
    #20 
    a=4'b1110;
    b=4'b1011;
    #20 
    a=4'b1000;
    b=4'b1001;

    $finish;    
    end 
     sumator main(
       .sum(),
       .a(a),
       .b(b)
     ); 
endmodule