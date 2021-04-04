`timescale 1ns / 1ps

module Oled_DRIVER_visualiser(input [1:0] toggle_border, input [1:0] toggle_color, input show_bar, 
input btnL, input btnR, input btnC, input btnU, input btnD, input clk24, input [15:0] volume10, input [15:0] volume24, input [6:0] X,
input [6:0] Y, output [15:0] oled_AUDVIS, output exit_AUDVIS, input [2:0] display_flag, input toggle_mode);

    wire [15:0] bg_col;
    wire [15:0] border_data;
    wire [15:0] bar_data;
    wire [1:0] border_width;
    
    assign bg_col = (toggle_color == 2'b11) ? 16'h3049 :
                    (toggle_color == 2'b10) ? 16'h0161 :
                    (toggle_color == 2'b01) ? 16'h0927 :
                    16'h0000;
                        
    Oled_Border OB(toggle_color, toggle_border, bg_col, X, Y, border_data, border_width);
    volume_bar_oled VBO(toggle_color, show_bar, btnL, btnR, btnC, btnU, btnD, clk24, bg_col, border_width, volume10, volume24, 
    X, Y, bar_data, exit_AUDVIS, display_flag, toggle_mode);
    
    assign oled_AUDVIS = (X < border_width || X >= 96 - border_width || Y < border_width || Y >= 64 - border_width) ? border_data : bar_data;
    
endmodule
