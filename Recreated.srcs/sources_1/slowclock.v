`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2021 11:45:27
// Design Name: 
// Module Name: slowclock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module slowclock(input CLOCK, output reg SLOWCLOCK = 0, input [31:0] num);

    integer COUNT = 0;
    
    always@(posedge CLOCK) begin
        COUNT <= (COUNT == num) ? 0 : COUNT + 1;
        SLOWCLOCK <= (COUNT == num) ? ~SLOWCLOCK : SLOWCLOCK;
    end

endmodule
