`timescale 1ns/1ps

module automatfinit(
 output reg out,
 input valoare,
 input clk,
 input rst
 );
    parameter S0=3'd0,S1=3'd1,S2=3'd2;
    reg [1:0]state;
    reg [1:0]next_state;
    always @(posedge clk or posedge rst) begin
    if(rst)begin
    state<=S0;
    end else begin
    state<=next_state; 
        end
    end
    always @*begin 
    next_state=state;
    case(state)
   S0: begin
        if(valoare==1)begin
         next_state<=S1;
        end else begin 
        next_state<=S0;
            end
        end
    S1: begin
        if(valoare==0)begin
        next_state<=S2;
        end else begin
        next_state<=S1;
            end
        end 
      S2: begin
        if(valoare==1)begin
        next_state<=S2;
        end else begin 
        next_state<=S2;
            end
        end   
        default:
        next_state <=S0;
        endcase
    end
 always @* begin
        case (state)
            S0: out = 1'b0;
            S1: out = 1'b0;
            S2: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule
