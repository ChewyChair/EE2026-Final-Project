`timescale 1ns / 1ps


module rng_6bit_2(input clk, output [5:0] OUT);

    reg [5:0] curr = 3'b000001;
    wire [5:0] next;
    wire feedback;
    
    always@(posedge clk) begin
        curr <= next;
    end
    
    assign feedback = curr[4] ^ curr[5] | curr[0] ^ curr[2] & curr[1] ^ curr[3];
    assign next = {feedback, curr[5:1]};
    
    assign OUT = curr;

endmodule