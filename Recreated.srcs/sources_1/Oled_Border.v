`timescale 1ns / 1ps

module Oled_Border(input [1:0] toggle_color, input [1:0] toggle_border, input [15:0] bg_col, 
input [6:0] X, input [6:0] Y, output [15:0] border_data, output [1:0] border_width);
     
    wire [15:0] bord_col;
     
    assign bord_col = (toggle_color == 2'b11) ? 16'hC01F : 
                      (toggle_color == 2'b10) ? 16'h07E9 : 
                      (toggle_color == 2'b01) ? 16'h06DF : 
                      16'hFFFF;
    assign border_width = (toggle_border == 2'b11) ? 2'd3 :
                          (toggle_border == 2'b10) ? 2'd2 :
                          (toggle_border == 2'b01) ? 2'd1 :
                          2'd0; 
    assign border_data = (X < border_width || X >= 96 - border_width || Y < border_width || Y >= 64 - border_width) ? bord_col : bg_col;
    
endmodule
