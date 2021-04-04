`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2021 22:05:47
// Design Name: 
// Module Name: getcoords
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


module getcoords(input [12:0] pixel_index, output [6:0] X, output [6:0] Y);
    
    assign X = pixel_index % 96;
    assign Y = pixel_index / 96;
    
endmodule
