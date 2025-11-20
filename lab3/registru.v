`timescale 1ns/1ps

module registruelementar(
  input clk,
  input rst_n,
  input we,
  input oe,
  
  input[7:0] data_in,
  output [7:0]data_out,
  output [7:0]disp_out
    );
    reg[7:0]mem;
    
    always@(posedge clk)begin
    if(!rst_n )begin
    mem<={8{1'b0}};
        end else if(we) begin
    mem<=data_in;
        end
    end
    assign disp_out =mem;
    assign data_out =oe?mem:{8{1'b0}};
endmodule