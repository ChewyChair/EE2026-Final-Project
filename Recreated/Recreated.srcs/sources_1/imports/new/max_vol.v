`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2021 10:00:34
// Design Name: 
// Module Name: max_vol
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


module max_vol(input clk20k, input clk10, input clk24, input [11:0] mic_in, output reg [15:0] volume10 = 0, output reg [15:0] volume24 = 0);

    reg [14:0] count = 0;
    reg [9:0] counter = 0;
    reg [11:0] max = 0;
    integer value = 0;
    
    always@(posedge clk20k) begin
        counter <=  (counter == 10'd999) ? 0 : counter + 1; 
        max <= (counter == 10'd0) ? 0 : (mic_in > max) ? mic_in : max; 
    end
    
    always@(posedge clk10) begin
        value = (max - 12'd2064);
        if (value >= 0 && value < 3) volume10 = 16'd0;
        else if (value >= 3 && value < 4) volume10 = 16'd1;
        else if (value >= 4 && value < 7) volume10 = 16'd3;
        else if (value >= 7 && value < 11) volume10 = 16'd7;
        else if (value >= 11 && value < 16) volume10 = 16'd15;
        else if (value >= 16 && value < 22) volume10 = 16'd31;
        else if (value >= 22 && value < 30) volume10 = 16'd63;
        else if (value >= 30 && value < 40) volume10 = 16'd127;      
        else if (value >= 40 && value < 52) volume10 = 16'd255;
        else if (value >= 52 && value < 65) volume10 = 16'd511;
        else if (value >= 65 && value < 78) volume10 = 16'd1023;
        else if (value >= 78 && value < 93) volume10 = 16'd2047;
        else if (value >= 93 && value < 115) volume10 = 16'd4095;
        else if (value >= 115 && value < 150) volume10 = 16'd8191;
        else if (value >= 160 && value < 220) volume10 = 16'd16383;      
        else if (value >= 220 && value < 300) volume10 = 16'd32767;
        else if (value >= 300) volume10 = 16'd65535;
    end
    
    always@(posedge clk24) begin
    value = (max - 12'd2064);
        if (value >= 0 && value < 3) volume24 = 16'd0;
        else if (value >= 3 && value < 4) volume24 = 16'd1;
        else if (value >= 4 && value < 7) volume24 = 16'd3;
        else if (value >= 7 && value < 11) volume24 = 16'd7;
        else if (value >= 11 && value < 16) volume24 = 16'd15;
        else if (value >= 16 && value < 22) volume24 = 16'd31;
        else if (value >= 22 && value < 30) volume24 = 16'd63;
        else if (value >= 30 && value < 40) volume24 = 16'd127;      
        else if (value >= 40 && value < 52) volume24 = 16'd255;
        else if (value >= 52 && value < 65) volume24 = 16'd511;
        else if (value >= 65 && value < 78) volume24 = 16'd1023;
        else if (value >= 78 && value < 93) volume24 = 16'd2047;
        else if (value >= 93 && value < 115) volume24 = 16'd4095;
        else if (value >= 115 && value < 150) volume24 = 16'd8191;
        else if (value >= 160 && value < 220) volume24 = 16'd16383;      
        else if (value >= 220 && value < 300) volume24 = 16'd32767;
        else if (value >= 300) volume24 = 16'd65535;
    end
            
endmodule
