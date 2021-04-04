`timescale 1ns / 1ps

module Oled_DRIVER_main(input clk24, input [2:0] select_flag, output [15:0] oled_data, input [15:0] oled_MENU,  input [15:0] oled_AUDVIS, input [15:0] oled_SBR, 
input [15:0] oled_shooter, input [15:0] oled_PONG, input [15:0] oled_towerdef, input exit_AUDVIS, input exit_SBR, input exit_shooter, input exit_pong, input exit_towerdef, 
output reg [2:0] display_flag = 3'd4, input secret);
    
    always@(posedge clk24) begin
        if (exit_AUDVIS || exit_SBR || exit_towerdef || exit_shooter || exit_pong) display_flag = 3'd4;
        else if (select_flag != 3'd4) display_flag = select_flag;
    end   
    
    assign oled_data = (secret) ? oled_shooter :
                       (display_flag == 3'd0) ? oled_AUDVIS :
                       (display_flag == 3'd1) ? oled_SBR :
                       (display_flag == 3'd2) ? oled_PONG :
                       (display_flag == 3'd3) ? oled_towerdef :
                       oled_MENU;
    
endmodule
