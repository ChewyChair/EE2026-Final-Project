`timescale 1ns / 1ps

module Oled_DRIVER_towerdef(input clk, input clk24, input [15:0] volume24, input pause, input btnD, input btnU, input btnC, input btnL, input [6:0] X, input [6:0] Y, input [12:0] pixel_index,
 output reg [15:0] oled_towerdef, output reg exit_towerdef = 0, input [1:0] display_flag, output reg [5:0] score = 0, output reg [1:0] forcefield_gen = 0);
    
    wire health;
    wire [15:0] health_col;
    wire health_border;
    reg [10:0] tower_hp = 11'd752;
    wire tower;
    wire background_sky;
    wire background_land;
    wire background_sea;
    wire window;
    wire forcefield;
    
    // Forcefield generator
    reg [6:0] forcefield_counter = 7'd0;
    reg forcefield_flag = 0;
    reg [4:0] forcefield_duration = 5'd0;
        
    // Enemy generator
    wire [5:0] enemy_gen;
    wire [5:0] enemy2_gen;
    wire [5:0] enemy3_gen;
    rng_6bit rng_6x_enemy(clk, enemy_gen);
    rng_6bit_2 rng_6x_enemy2(clk, enemy2_gen);
    rng_6bit_3 rng_6x_enemy3(clk, enemy3_gen);
    
    // Shared enemy properties
    reg [2:0] enemy_speed = 3'd1;
    reg [9:0] damage = 10'd32;
    
    // Enemy element
    wire enemy;
    reg [5:0] enemy_posY = 6'd35;
    reg [6:0] enemy_posX = 7'd0;
    reg hit = 0;
    reg sky_flag = 0;
    reg land_flag = 0;
    reg sea_flag = 0;
    
    // Enemy 2 element
    wire enemy2;
    reg [5:0] enemy2_posY = 6'd16;
    reg [6:0] enemy2_posX = 7'd0;
    reg hit2 = 0;
    reg [5:0] enemy2_delay = 6'd0;
    reg sky2_flag = 0;
    reg land2_flag = 0;
    reg sea2_flag = 0;
    
    // Enemy 3 element
    wire enemy3;
    reg enemy3_flag = 0;
    reg [5:0] enemy3_posY = 6'd47;
    reg [6:0] enemy3_posX = 7'd0;
    reg hit3 = 0;
    reg [5:0] enemy3_delay = 6'd0;
    reg sky3_flag = 0;
    reg land3_flag = 0;
    reg sea3_flag = 0;
    
    assign enemy = (sky_flag == 1 || land_flag == 1 || sea_flag == 1) ?  0 : (Y >= enemy_posY && (Y <= enemy_posY + 1)) && (X >= enemy_posX && X <= enemy_posX + 4);
    assign enemy2 = (enemy2_delay == 6'd55) ? (sky2_flag == 1 || land2_flag == 1 || sea2_flag == 1) ?  0 : 
     ((Y >= enemy2_posY && (Y <= enemy2_posY +1)) && (X >= enemy2_posX && X <= enemy2_posX + 4)) : 0;
    assign enemy3 = (enemy3_delay == 6'd55) ? (sky3_flag == 1 || land3_flag == 1 || sea3_flag == 1) ?  0 :
     ((Y >= enemy3_posY && (Y <= enemy3_posY +1)) && (X >= enemy3_posX && X <= enemy3_posX + 4)) : 0;
    
    // Defence elements
    wire pulse_U, pulse_C, pulse_D;
    debounced_button DB_U(clk24, btnU, pulse_U);
    debounced_button DB_C(clk24, btnC, pulse_C);
    debounced_button DB_D(clk24, btnD, pulse_D);
            
    reg [4:0] hold_L = 5'd0;
    wire pulse_L;
    debounced_button DB_L(clk24, btnL, pulse_L);
    
    // Game elements
    reg [15:0] oled_title;
    reg [15:0] oled_gameover;
    reg [15:0] oled_win;
    reg [15:0] oled_game;
    reg [15:0] oled_bg;
    reg game_over = 0;
    //reg [3:0] score = 0;
    reg win = 0;
    
    // Title elements
    wire towerdef_title;
    reg [15:0] towerdef_gameover[6143:0];
    reg [15:0] towerdef_win[6143:0];
    reg [15:0] towerdef_bg[6143:0];
    reg [5:0] title_timer = 6'd0;
               
    assign window = ((X >= 89 && X <= 93) && (Y == 16 || Y == 18 || Y == 20 || Y == 22 || Y == 24)) || ((X >= 90 && X <= 92) && Y == 15) || ((X == 88 || X == 91 || X == 94) && (Y >= 17 && Y <= 24)) ||
     ((X >= 89 && X <= 93) && (Y == 30 || Y == 32 || Y == 34 || Y == 36 || Y == 38)) || ((X >= 90 && X <= 92) && Y == 29) || ((X == 88 || X == 91 || X == 94) && (Y >= 31 && Y <= 38));
    assign background_sky = ((X >= 0 && X <= 85) && (Y >= 0 && Y <= 24)) || (((X >= 88 && X <= 89) || (X >= 92 && X <= 93)) && (Y >= 0 && Y <= 10));    
    assign background_land = ((X >= 0 && X <= 85) && (Y >= 25 && Y <= 44));
    assign background_sea = ((X >= 0 && X <= 85) && (Y >= 45 && Y <= 63));
    assign forcefield = (forcefield_flag == 1) ? ((Y >= 5 && Y <= 63) && (X >= 60 && X <= 82)) : 0;
    assign tower = ((X >= 86 && X <= 95) && (Y >= 6 && Y <= 63));
    assign health_border = ((X >= 0 && X <= 95) && (Y == 0 || Y == 4)) || ((X == 0 || X == 95) && (Y >= 0 && Y <= 4));
    assign health = (X >= 1 && X <= tower_hp / 8) && (Y >= 1 && Y <= 3);
    assign health_col = (tower_hp >= 11'd461) ? 16'h87EA : (tower_hp >= 11'd230) ? 16'hFFAA : 16'hFA8A;
    
    
    assign towerdef_title = ((X >= 8 && X <= 22) && (Y >= 8 && Y <= 10)) || ((X >= 14 && X <= 16) && (Y >= 11 && Y <= 29)) || // T
     ((X >= 24 && X <= 26) && (Y >= 8 && Y <= 29)) || ((X >= 27 && X <= 31) && ((Y >= 8 && Y <= 10) || (Y >= 27 && Y <= 29))) || 
     ((X >= 32 && X <= 33) && ((Y >= 9 && Y <= 11) || (Y >= 26 && Y <= 28))) || ((X >= 34 && X <= 35) && (Y >= 10 && Y <= 27)) || (X == 36 && (Y >= 11 && Y <= 26)); // D 
    
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
    
    initial begin
        $readmemh("towerdef_lose.mem", towerdef_gameover);
        $readmemh("towerdef_win.mem", towerdef_win);
        $readmemh("towerdef_bg.mem", towerdef_bg);
    end
    
    always@(posedge clk24) begin
        if (display_flag == 3'd3) begin
            if (pulse_L) begin
                hold_L = 5'b0;
                exit_towerdef = 0;
                title_timer = 0;
                enemy_posX = 0;
                enemy_posY = 35;
                enemy2_posY = 16;
                enemy2_posX = 0;
                enemy3_posY = 47;
                enemy3_posX = 0;
                forcefield_gen = 0;
                forcefield_counter = 0;
                forcefield_flag = 0;
                forcefield_duration = 0;
                enemy2_delay = 0;
                enemy3_delay = 0;
            end
            if (title_timer == 6'd47 && !game_over) begin
                // Pause function
                if (pause) begin
                end
                else begin
                    forcefield_counter <= (forcefield_counter == 127) ? 0 : forcefield_counter + 1;
                    forcefield_gen <= (forcefield_gen == 3) ? forcefield_gen : (forcefield_counter == 127 && !game_over) ? forcefield_gen + 1 : forcefield_gen;
                    if (volume24 >= 511 && forcefield_gen > 0 && forcefield_flag != 1) begin
                        forcefield_flag <= 1;
                        forcefield_gen <= forcefield_gen - 1;
                    end
                    if (forcefield_flag == 1) begin
                        forcefield_duration <= (forcefield_duration == 24) ? 0 : forcefield_duration + 1;
                        forcefield_flag <= (forcefield_duration == 24) ? 0 : forcefield_flag;
                    end
                    enemy2_delay <= (enemy2_delay == 55) ? 55 : enemy2_delay + 1;
                    enemy3_delay <= (enemy3_flag == 1) ? (enemy3_delay == 55) ? 55 : enemy3_delay + 1 : 0;
                    // Enemy
                    enemy_posY <= (enemy_posX >= 7'd82) ? (enemy_gen <= 5 || enemy_gen > 63) ? enemy_gen + 5: enemy_gen : enemy_posY;
                    enemy_posX <= (enemy_posX >= 7'd82) ? 0 : enemy_posX + enemy_speed;
                    // Enemy 2
                    enemy2_posY <= (enemy2_delay == 55) ? (enemy2_posX >= 7'd82) ? (enemy2_gen <= 5 || enemy2_gen > 63) ? enemy2_gen + 5:
                     enemy2_gen : enemy2_posY : enemy2_posY;
                    enemy2_posX <= (enemy2_delay == 55) ? (enemy2_posX >= 7'd82) ? 0 : enemy2_posX + enemy_speed : 0;
                    // Enemy 3
                    enemy3_posY <= (enemy3_delay == 55) ? (enemy3_posX >= 7'd82) ? (enemy3_gen <= 5 || enemy3_gen > 63) ? enemy3_gen + 5:
                     enemy3_gen : enemy3_posY : enemy3_posY;
                    enemy3_posX <= (enemy3_delay == 55) ? (enemy3_posX >= 7'd82) ? 0 : enemy3_posX + enemy_speed : 0;        
                end
            end
        end
        else begin
            hold_L = 5'b0;
            exit_towerdef = 0;
            title_timer = 0;
            enemy_posX = 0;
            enemy_posY = 35;
            enemy2_posY = 16;
            enemy2_posX = 0;
            enemy3_posY = 47;
            enemy3_posX = 0;
            forcefield_gen = 0;
            forcefield_counter = 0;
            forcefield_flag = 0;
            forcefield_duration = 0;
            enemy2_delay = 0;
            enemy3_delay = 0;
        end
        title_timer <= (title_timer == 6'd47) ? 6'd47 : title_timer + 1;
        hold_L <= (btnL) ? (hold_L == 5'd23) ? 5'd23 : hold_L + 1 : 0;
        if (hold_L == 5'd23) exit_towerdef = 1;      
    end
    
    always@(posedge clk) begin
        if (display_flag == 3'd3) begin
            if (pulse_L) begin
                game_over = 0;
                score = 0;
                win = 0;
                hit = 0;
                hit2 = 0;
                hit3 = 0;
                enemy3_flag = 0;
                sky_flag = 0;
                land_flag = 0;
                sea_flag = 0;
                sky2_flag = 0;
                land2_flag = 0;
                sea2_flag = 0;
                sky2_flag = 0;
                land3_flag = 0;
                sea3_flag = 0;
                enemy_speed = 2'd1;
                damage = 10'd32;
                tower_hp = 11'd752;
            end
            // Damage interaction
            if (enemy && tower && !hit) begin
                tower_hp = tower_hp - damage;
                hit = 1;
            end
            if (enemy2 && tower && !hit2) begin
                tower_hp = tower_hp - damage;
                hit2 = 1;
            end
            if (enemy3 && tower && !hit3) begin
                tower_hp = tower_hp - damage;
                hit3 = 1;
            end
            if (enemy_posX == 0) hit = 0;
            if (enemy2_posX == 0) hit2 = 0;
            if (enemy3_posX == 0) hit3 = 0;
            
            // Enemy
            if ((pulse_U && enemy_posY >= 6 && enemy_posY <= 24 && enemy_posX >= 63 && enemy_posX <= 82 && sky_flag == 0) || (enemy && forcefield && sky_flag == 0)) begin
                sky_flag = 1;
                score = score + 1;
            end
            else if ((pulse_C && enemy_posY >= 25 && enemy_posY <= 44 && enemy_posX >= 63 && enemy_posX <= 82 && land_flag == 0) || (enemy && forcefield && land_flag == 0)) begin
                land_flag = 1;
                score = score + 1;
            end 
            else if ((pulse_D && enemy_posY >= 45 && enemy_posY <= 63 && enemy_posX >= 63 && enemy_posX <= 82 && sea_flag == 0) || (enemy && forcefield && sea_flag == 0))begin
                sea_flag = 1;
                score = score + 1;
            end
            if (enemy_posX == 0) begin
                sky_flag = 0;
                land_flag = 0;
                sea_flag = 0;
            end         
            
            // Enemy 2
            if ((pulse_U && enemy2_posY >= 6 && enemy2_posY <= 24 && enemy2_posX >= 63 && enemy2_posX <= 82 && sky2_flag == 0) || (enemy2 && forcefield && sky2_flag == 0)) begin
                sky2_flag = 1;
                score = score + 1;
            end
            else if ((pulse_C && enemy2_posY >= 25 && enemy2_posY <= 44 && enemy2_posX >= 63 && enemy2_posX <= 82 && land2_flag == 0) || (enemy2 && forcefield && land2_flag == 0)) begin
                land2_flag = 1;
                score = score + 1;
            end 
            else if ((pulse_D && enemy2_posY >= 45 && enemy2_posY <= 63 && enemy2_posX >= 63 && enemy2_posX <= 82 && sea2_flag == 0) || (enemy2 && forcefield && sea2_flag == 0)) begin
                sea2_flag = 1;
                score = score + 1;
            end
            if (enemy2_posX == 0) begin
                sky2_flag = 0;
                land2_flag = 0;
                sea2_flag = 0;
            end
            
            // Enemy 3
            if ((pulse_U && enemy3_posY >= 6 && enemy3_posY <= 24 && enemy3_posX >= 63 && enemy3_posX <= 82 && sky3_flag == 0) || (enemy3 && forcefield && sky3_flag == 0)) begin
                sky3_flag = 1;
                score = score + 1;
            end
            else if ((pulse_C && enemy3_posY >= 25 && enemy3_posY <= 44 && enemy3_posX >= 63 && enemy3_posX <= 82 && land3_flag == 0) || (enemy3 && forcefield && land3_flag == 0)) begin
                land3_flag = 1;
                score = score + 1;
            end 
            else if ((pulse_D && enemy3_posY >= 45 && enemy3_posY <= 63 && enemy3_posX >= 63 && enemy3_posX <= 82 && sea3_flag == 0) || (enemy3 && forcefield && sea3_flag == 0)) begin
                sea3_flag = 1;
                score = score + 1;
            end
            if (enemy3_posX == 0) begin
                sky3_flag = 0;
                land3_flag = 0;
                sea3_flag = 0;
            end
            
            if (tower_hp == 0 || tower_hp > 768) game_over = 1;
            if (score >= 8) begin 
                enemy_speed = 3'd2;
                damage = 10'd64;
            end
            if (score >= 15) begin 
                enemy_speed = 3'd3;
                damage = 10'd128;
            end
            if (score >= 20) begin 
                enemy3_flag = 1;
            end
            if (score >= 50) win = 1;
            oled_title = (towerdef_title) ? 16'hF800 : (background_sky) ? 16'h271E : (background_land) ? 16'h1E08 : (background_sea) ? 16'h4457 : 
                         (window) ? 16'h5ACB : (tower) ? 16'hA514 : 16'hffff;
            oled_gameover = towerdef_gameover[pixel_index];
            oled_win = towerdef_win[pixel_index];
            oled_bg = towerdef_bg[pixel_index];
            oled_game = (health_border) ? 16'h0000 : (health) ? health_col : oled_bg;
            
            if (enemy || enemy2 || enemy3) 
               oled_game = 16'hF800;
            
            if (forcefield)
               oled_game = 16'hFC3E;
            
            if (pause_text)
               oled_game = 16'hE861;
            
            oled_towerdef = (title_timer == 6'd47) ? (win) ? oled_win : (game_over) ? oled_gameover : oled_game : oled_title;
        end else begin
            game_over = 0;
            score = 0;
            win = 0;
            hit = 0;
            hit2 = 0;
            hit3 = 0;
            enemy3_flag = 0;
            sky_flag = 0;
            land_flag = 0;
            sea_flag = 0;
            sky2_flag = 0;
            land2_flag = 0;
            sea2_flag = 0;
            sky2_flag = 0;
            land3_flag = 0;
            sea3_flag = 0;
            enemy_speed = 2'd1;
            damage = 10'd32;
            tower_hp = 11'd752;
        end
    end       
    
endmodule