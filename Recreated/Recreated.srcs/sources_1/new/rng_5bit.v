`timescale 1ns / 1ps


module rng_5bit(input clk, output [4:0] OUT);

    reg [4:0] curr = 3'b00001;
    wire [4:0] next;
    wire feedback;
    
    always@(posedge clk) begin
        curr <= next;
    end
    
    assign feedback = curr[4] ^ curr[3] ^ curr[2] ^ curr[1] ^ curr[0];
    assign next = {feedback, curr[4:1]};
    
    assign OUT = curr;

endmodule

