`timescale 1ns / 1ps

module testbench();
    reg a;
    reg b;
    wire less; 
wire equal;
wire greater;
    initial begin
        $dumpfile("comparator.vcd");  // Numele fișierului generat
        $dumpvars(0, testbench);
    a=1;
    b=0;
    #20 
    a=0;
    b=1;
    #20 
    a=1;
    b=1;
    $finish;
    end 
     comparator main(
       .less(less),
       .equal(equal),
       .greater(greater),
       .a(a),
       .b(b)
     ); 
endmodule