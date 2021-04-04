`timescale 1ns / 1ps

module Oled_DRIVER_menu(input [1:0] toggle_color, input clk3, input clk24, output reg [2:0] select_flag = 3'd4, input btnU, input btnD, input btnC, input btnL, input btnR,
input [7:0] X, input [7:0] Y, output [15:0] oled_MENU, input [2:0] display_flag, input exit_shooter, output reg secret = 0);

    reg [1:0] hover_flag = 2'd0;
    wire pulse_U;
    wire pulse_D;
    wire pulse_C;
    wire pulse_L;
    wire pulse_R;
    reg [4:0] hold_L;
    reg [4:0] hold_R;
    reg [3:0] secret_delay = 4'd0;
    reg [3:0] secret_stage = 4'd0;
    
    debounced_button DB_U(clk24, btnU, pulse_U);
    debounced_button DB_D(clk24, btnD, pulse_D);
    debounced_button DB_C(clk24, btnC, pulse_C);
    debounced_button DB_L(clk24, btnL, pulse_L);
    debounced_button DB_R(clk24, btnR, pulse_R);
    
    menu_oled MO(toggle_color, clk3, hover_flag, X, Y, oled_MENU);
        
    always@(posedge clk24) begin
        if (exit_shooter) secret = 0;
        if (display_flag == 3'd4) begin
            hold_L <= (btnL) ? (hold_L == 5'd23) ? 5'd23 : hold_L + 1 : 0;
            hold_R <= (btnR) ? (hold_R == 5'd23) ? 5'd23 : hold_R + 1 : 0;
            if (secret_delay == 4'd0) secret_stage = 4'd0;
            if (secret_stage == 4'd8) secret = 1;
            if (pulse_U) begin
                hover_flag = hover_flag - 1;
                if (secret_stage == 4'd0) begin
                    secret_delay = 4'd8;
                    secret_stage = 4'd1;
                end
            end
            else if (pulse_D) begin
                hover_flag = hover_flag + 1;
                if (secret_stage == 4'd1) begin
                    secret_delay = 4'd8;
                    secret_stage = 4'd2;
                end
            end
            else if (pulse_L) begin
                if (secret_stage == 4'd2) begin
                    secret_delay = 4'd8;
                    secret_stage = 4'd3;
                end
                else if (secret_stage == 4'd6) begin
                    secret_delay = 4'd8;
                    secret_stage = 4'd7;
                end
            end
            else if (pulse_R) begin
                    if (secret_stage == 4'd3) begin
                    secret_delay = 4'd8;
                    secret_stage = 4'd4;
                end
                else if (secret_stage == 4'd7) begin
                    secret_delay = 4'd8;
                    secret_stage = 4'd8;
                end
            end
            else if (pulse_C) begin
                if (secret_stage == 4'd4) begin
                    secret_delay = 4'd8;
                    secret_stage = 4'd5;
                end 
                else if (secret_stage == 4'd5) begin
                    secret_delay = 4'd8;
                    secret_stage = 4'd6;
                end
                else select_flag = hover_flag; 
            end
            else hover_flag = hover_flag;
            secret_delay = (secret_delay == 4'd0) ? 4'd0 : secret_delay - 1;
        end
        else begin
            select_flag = 3'd4;
        end           
    end
    
endmodule
