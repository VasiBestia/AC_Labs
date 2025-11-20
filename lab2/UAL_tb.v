`timescale 1ns/1ps

module testbench();
    reg [3:0]a;
    reg [3:0]b;
    reg op;
    wire[4:0]sum;
    wire[7:0]mult;
    initial begin
    $dumpfile("UAL_tb.vcd");
    $dumpvars(0,testbench);
        $monitor("T=%0t: Op=%b | A=%d, B=%d | SUM=%d, MULT=%d", 
                 $time, op, a, b, sum, mult);
    end
    initial begin
    a=4'b1100;
    b=4'b1111;
    op=1;
    #20 
    a=4'b1110;
    b=4'b1011;
    op=0;
    #20 
    a=4'b1000;
    b=4'b1001;
    op=1;
    #20
    $finish;
    end 
     comparator main(
     .sum(),
       .mult(),
       .a(a),
       .b(b),
       .op(op)
     ); 
endmodule