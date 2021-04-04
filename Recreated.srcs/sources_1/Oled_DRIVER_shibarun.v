`timescale 1ns / 1ps

module Oled_DRIVER_shibarun(input clk, input clk24, input toggle_mode, input toggle_cheat, input pause, input [15:0] volume24, input btnU, input btnL, input btnR, input btnC, input [6:0] X, input [6:0] Y, 
input [12:0] pixel_index, output reg [15:0] oled_SBR, output reg exit_SBR = 0, input [1:0] display_flag, output reg [9:0] score = 10'd0);
    
    reg [4:0] hold_C = 5'd0;
    reg [15:0] shibarun_title[6143:0];
    reg [15:0] shibarun_gameover[6143:0];
    reg [5:0] title_timer = 6'd0;
    
    initial begin
    $readmemh("shiba.mem", shibarun_title);
    $readmemh("sbr_gameover.mem", shibarun_gameover);
    end
    
    wire pulse_U;
    wire pulse_C;
    
    debounced_button DB_U(clk24, btnU, pulse_U);
    debounced_button DB_C(clk24, btnC, pulse_C);
    
    reg [15:0] oled_title;
    reg [15:0] oled_gameover;
    reg [15:0] oled_game;
    reg [6:0] shiba_height = 7'd59;
    reg [6:0] shiba_point = 7'd5;
    reg [2:0] shiba_anim_counter = 3'd0;
    reg shiba_jump = 0;
    reg [5:0] shiba_vel = 6'd0;
    reg shiba_float = 0;
    reg [5:0] shiba_fall = 6'd0;
    reg shiba_jump_clock = 0;
    reg shiba_anim_state;
    wire shiba_sprite;
    wire shiba_base;
    wire shiba_black;
    wire shiba_pink;
    wire shiba_white;
    wire background_sky;
    wire background_ground;
    
    assign shiba_base = ((Y <= shiba_height - 2 && Y >= shiba_height - 9) && (X >= shiba_point + 2 && X <= shiba_point + 13)) || 
    ((Y <= shiba_height - 10 && Y >= shiba_height - 11) && (X >= shiba_point + 11 && X <= shiba_point + 12)) || 
    ((Y <= shiba_height - 5 && Y >= shiba_height - 6) && (X >= shiba_point + 14 && X <= shiba_point + 15)) || 
    ((Y <= shiba_height - 4 && Y >= shiba_height - 5) && (X >= shiba_point && X <= shiba_point + 1));
    
    assign shiba_pink = (X >= shiba_point + 10 && X <= shiba_point + 11) && (Y <= shiba_height - 5 && Y >= shiba_height - 6);
    assign shiba_black = ((X >= shiba_point + 11 && X <= shiba_point + 12) && Y == shiba_height - 7) || (X == shiba_point + 15 && Y == shiba_height -6);
    assign shiba_white = ((X >=  shiba_point + 6 && X <= shiba_point + 9) && (Y == shiba_height - 2)) || (Y == shiba_height - 4 && (X >= shiba_point + 14 && X <= shiba_point + 15));
    
    assign shiba_sprite = (shiba_height < 59) ? (shiba_base || ((Y <= shiba_height && Y >= shiba_height - 1) && (X >= shiba_point + 4 && X <= shiba_point + 11))) : //floating sprite
    (shiba_anim_state) ? (shiba_base || ((Y <= shiba_height && Y >= shiba_height - 1) && 
    (X == shiba_point + 3 || X == shiba_point + 4 || X == shiba_point + 5 || X == shiba_point + 6 || X == shiba_point + 9 || X == shiba_point + 10 || X == shiba_point + 12 || X == shiba_point + 13))) :  //anim frame 1
    (shiba_base || ((Y <= shiba_height - 1 && Y >= shiba_height - 2) && (X == shiba_point + 1 || X == shiba_point + 2 || X == shiba_point + 13 || X == shiba_point + 14)) ||
    ((Y <= shiba_height && Y >= shiba_height - 1) && (X == shiba_point + 4 || X == shiba_point + 5 || X == shiba_point + 10 || X == shiba_point + 11)));   //anim frame 2
    
    assign background_sky = (Y >= 0 && Y <= 59);
    assign background_ground = (Y >= 60 && Y <= 63);
    
    wire [1:0] obstacle;
    reg [6:0] obstaclepos0 = 7'd90;
    reg [6:0] obstaclepos1 = 7'd90;
    reg [2:0] obstaclespeed = 2'd1;
    wire [2:0] random1;
    wire [6:0] random2;
    reg [2:0] random0x, random1x;
    reg [5:0] random0y, random1y; 
    wire [2:0] random3;
    wire [5:0] random6;
    reg [5:0] obstacledelay = 6'd0;
    wire [4:0] diff_mult;
    
    rng_6bit rng6x(clk, random6);
    rng_6bit rng3x(clk, random3);
    
    assign diff_mult = (toggle_mode) ? 5'd20 : 0;
//    assign obstacle[0] = (X >= obstaclepos0 && X  <= obstaclepos0 + 6'd8) && ((Y <= 6'd59 && Y >= 6'd0) && !(Y <= random0y + 6'd20 + diff_mult && Y >= random0y));
//    assign obstacle[1] = (obstacledelay == 6'd55) ? ((X >= obstaclepos1 && X  <= obstaclepos1 + 6'd8) && ((Y <= 6'd59 && Y >= 6'd0) && !(Y <= random1y + 6'd20 + diff_mult && Y >= random1y))) : 0;
    assign obstacle[0] = (X >= obstaclepos0 && X  <= obstaclepos0 + 6'd8) && ((Y <= 6'd59 && Y >= 6'd0) && !(Y <= random0y + 6'd24 + diff_mult && Y >= random0y));
    assign obstacle[1] = (obstacledelay == 6'd55) ? ((X >= obstaclepos1 && X  <= obstaclepos1 + 6'd8) && ((Y <= 6'd59 && Y >= 6'd0) && !(Y <= random1y + 6'd24 + diff_mult && Y >= random1y))) : 0;
    
    reg game_over = 0;
    reg [4:0] scoretick = 5'd0;
    reg pause_flag = 0;
    wire pause_text;
    
    assign pause_text = (pause) ? ((X >= 4 && X <= 7) && (Y >= 16 && Y <= 45)) || (((Y >= 16 && Y <= 31) && (X >= 4 && X <= 19))
    && !((Y >= 20 && Y <= 27) && (X >= 8 && X <= 15))) || //P
    (((X >= 22 && X <= 37) && (Y >= 16 && Y <= 45)) && !((Y >= 20 && Y <= 27) && (X >= 26 && X <= 33)) &&
    !((Y >= 32 && Y <= 45) && (X >= 26 && X <= 33))) || //A
    ((X >= 40 && X <= 55) && (Y >= 16 && Y <= 45) && !(X >= 44 && X <= 51 && Y >= 16 && Y <= 41)) || //U
    ((X >= 58 && X <= 73) && (Y >= 16 && Y <= 45) && !(X >= 62 && X <= 73 && Y >= 20 && Y <= 28) &&
    !(X >= 58 && X <= 69 && Y >= 33 && Y <= 41)) || //S
    ((X >= 76 && X <= 91) && (Y >= 16 && Y <= 45)) && !(X >= 80 && X <= 91 && ((Y >= 20 && Y <= 28) ||
    (Y >= 33 && Y <= 41))) : 0; //E 
    
    always@(posedge clk24) begin
        if (display_flag == 3'd1) begin
            if (pulse_C) begin
                hold_C = 5'b0;
                exit_SBR = 0;
                title_timer = 5'd0;
                shiba_height = 7'd59;
                shiba_point = 7'd5;   
                obstaclepos0 = 7'd95;
                obstaclepos1 = 7'd95;
                obstacledelay = 6'd0;
                score = 10'd0;
            end
            if (title_timer == 6'd47 && !game_over) begin
                if (pause) begin
                end                
                else begin
                    scoretick <= (scoretick == 5'd23) ? 0 : scoretick + 1;
                    score <= (scoretick == 5'd23) ?  score + 1 : score;  
                    obstaclepos0 <= (obstaclepos0 >= 7'd96 && obstaclepos0 <= 7'd119) ? 7'd95 : obstaclepos0 - obstaclespeed;
                    obstaclepos1 <= (obstacledelay == 6'd55) ? (obstaclepos1 >= 7'd96 && obstaclepos1 <= 7'd119) ? 7'd95 : obstaclepos1 - obstaclespeed : obstaclepos1;
                    obstacledelay <= (obstacledelay == 6'd55) ? 6'd55 : obstacledelay + 1;
                    random0y <= (obstaclepos0 >= 7'd96 && obstaclepos0 <= 7'd119) ? random6 : random0y;
                    random1y <= (obstaclepos1 >= 7'd96 && obstaclepos1 <= 7'd119) ? random6 : random1y;
                    random0x <= (obstaclepos0 >= 7'd96 && obstaclepos0 <= 7'd119) ? random3 : random0x;
                    random1x <= (obstaclepos1 >= 7'd96 && obstaclepos1 <= 7'd119) ? random3 : random1x;
                    if (shiba_point > 7'd1 && btnL) shiba_point = shiba_point - 1;
                    if (shiba_point < 7'd80 && btnR) shiba_point = shiba_point + 1;
                    if (shiba_height == 7'd59 && pulse_U) begin
                        shiba_jump = 1;
                        shiba_jump_clock = 3'd0;
                        shiba_vel = 6'd31; 
                        shiba_fall = 4'd0;
                    end
                    if (shiba_jump) begin
                        shiba_jump_clock <= (shiba_jump_clock) ? 0 : 1;
                        if (shiba_jump_clock == 1) begin
                            shiba_vel = shiba_vel / 2;
                            shiba_float = (btnU && shiba_vel == 0 && volume24 >= 16'd511) ? 1 : 0;
                            shiba_fall = (shiba_vel == 5'd0) ? (shiba_fall == 5'd0) ? 1 : (btnU) ? shiba_fall : (shiba_fall <  5'd8) ? shiba_fall +2 : 5'd12 : 0 ; 
                            shiba_height = (shiba_float) ? (shiba_height - 13 > 7'd63) ? 7'd11 : shiba_height - 2 : (shiba_vel > 5'd0) ? shiba_height - shiba_vel : (shiba_height + shiba_fall > 6'd59) ? 6'd59 : shiba_height + shiba_fall;
                            if (shiba_height == 7'd59) shiba_jump = 0;              
                        end
                    end
                end
                shiba_anim_counter <= (shiba_anim_counter == 3'd6) ? 0 : shiba_anim_counter + 1;
                shiba_anim_state = (shiba_anim_counter == 3'd6) ? ~shiba_anim_state : shiba_anim_state;
            end
            title_timer <= (title_timer == 6'd47) ? 6'd47 : title_timer + 1;
            hold_C <= (btnC) ? (hold_C == 5'd23) ? 5'd23 : hold_C + 1 : 0;
            if (hold_C == 5'd23) exit_SBR = 1;
        end
        else begin
            hold_C = 5'b0;
            exit_SBR = 0;
            title_timer = 5'd0;
            shiba_height = 7'd59;
            shiba_point = 7'd5;   
            obstaclepos0 = 7'd95;
            obstaclepos1 = 7'd95;
            obstacledelay = 6'd0;
            score = 10'd0;
        end
    end
    
    always@(posedge clk) begin      
        if (display_flag == 3'd1) begin
            if (pulse_C) begin
                obstaclespeed = 3'd1;            
                game_over = 0;      
            end
            if (!toggle_cheat && shiba_sprite && obstacle[1:0]) game_over = 1;    
            if (score >= 16'd100) obstaclespeed = 3'd6;
            else if (score >= 16'd80) obstaclespeed = 3'd5;
            else if (score >= 16'd60) obstaclespeed = 3'd4;
            else if (score >= 16'd40) obstaclespeed = 3'd3;        
            else if (score >= 16'd20) obstaclespeed = 3'd2;       
            oled_title = shibarun_title[pixel_index];
            oled_gameover = shibarun_gameover[pixel_index];
            oled_game = (pause_text) ? 16'hE861 : (obstacle[1:0]) ? 16'h0000 : (shiba_black) ? 16'h0000 : (shiba_pink) ? 16'hFCBD : (shiba_white) ? 16'hFFFF : (shiba_sprite) ? 16'hFE6D : (background_sky) ? 16'h35BF : 16'h44A6;
            oled_SBR = (title_timer == 6'd47) ? (game_over) ? oled_gameover : oled_game : oled_title;
        end
        else begin    
            obstaclespeed = 3'd1;            
            game_over = 0;                  
        end
    end       
    
endmodule

