`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2021 15:28:52
// Design Name: 
// Module Name: debounced_button
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


module debounced_button(input CLOCK, input BTN, output reg BTNDB = 0);

    wire c1,c2;
    
    always @(posedge CLOCK) begin
        BTNDB <= c1 && !c2;
    end
    
    DFF DFF1(CLOCK,BTN,c1);
    DFF DFF2(CLOCK,c1,c2);
    
endmodule
