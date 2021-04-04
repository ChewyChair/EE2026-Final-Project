`timescale 1ns / 1ps

module Oled_DRIVER_shooter(input clk, input clk24, input sw_bomb, input sw_beam, input toggle_mode, input toggle_cheat, input pause, input [15:0] volume24, input btnU, input btnD, input btnL, input btnR, 
input btnC, input [6:0] X, input [6:0] Y, input [12:0] pixel_index, output reg [15:0] oled_shooter, output reg exit_shooter = 0, input secret);
    
    reg [4:0] hold_C = 5'd0;
    reg [15:0] shooter_title[6143:0];
    reg [15:0] shooter_gameover[6143:0];
    reg [15:0] shooter_victory[6143:0];
    reg [5:0] title_timer = 6'd0;
    
    wire pulse_C;
    
    debounced_button DB_C(clk24, btnC, pulse_C);
    
    initial begin
    $readmemh("shooter.mem", shooter_title);
    $readmemh("shooter_go.mem", shooter_gameover);
    $readmemh("shooter_v.mem", shooter_victory);
    end
    
    reg [15:0] oled_title;
    reg [15:0] oled_gameover;
    reg [15:0] oled_victory;
    reg [15:0] oled_game;
    reg [6:0] jet_Y = 7'd47;
    reg [6:0] jet_X = 7'd5;
    reg [4:0] jet_fire_timer = 5'd0;
    wire [9:0] pBullet;
    wire pBeam;
    reg pBeamA = 0;
    reg [5:0] pBeam_fire_timer;
    wire pBeammarker;
    reg pBeammarkerA = 0;
    reg pBombarm = 0;
    reg pBombcharges = 1;
    reg pBeamarm = 0;
    reg pBeamcharges = 1;
    reg [4:0] bombbg = 5'd0;
    reg [1:0] L0, L1, L2, L3, L4, L5, L6, L7, L8, L9;
    reg [6:0] PBX0, PBX1, PBX2, PBX3, PBX4, PBX5, PBX6, PBX7, PBX8, PBX9;
    reg [6:0] PBY0, PBY1, PBY2, PBY3, PBY4, PBY5, PBY6, PBY7, PBY8, PBY9;
    reg [9:0] hit;
    reg hitbeam;
    
    assign pBullet[0] = (L0 == 2'd3) ? ((Y == PBY0 - 2 || Y == PBY0 - 1 || Y == PBY0 + 1 || Y == PBY0 + 2) && (X >= PBX0 && X <= PBX0 + 2)) :
                        (L0 == 2'd2) ? ((Y == PBY0 - 1 || Y == PBY0 + 1) && (X >= PBX0 && X <= PBX0 + 3)) :
                        (L0 == 2'd1) ? ((Y == PBY0 - 1 || Y == PBY0 + 1) && (X >= PBX0 && X <= PBX0 + 1)) : 0;
    assign pBullet[1] = (L1 == 2'd3) ? ((Y == PBY1 - 2 || Y == PBY1 - 1 || Y == PBY1 + 1 || Y == PBY1 + 2) && (X >= PBX1 && X <= PBX1 + 2)) :
    (L1 == 2'd2) ? ((Y == PBY1 - 1 || Y == PBY1 + 1) && (X >= PBX1 && X <= PBX1 + 3)) :
    (L1 == 2'd1) ? ((Y == PBY1 - 1 || Y == PBY1 + 1) && (X >= PBX1 && X <= PBX1 + 1)) : 0;
    assign pBullet[2] = (L2 == 2'd3) ? ((Y == PBY2 - 2 || Y == PBY2 - 1 || Y == PBY2 + 1 || Y == PBY2 + 2) && (X >= PBX2 && X <= PBX2 + 2)) :
    (L2 == 2'd2) ? ((Y == PBY2 - 1 || Y == PBY2 + 1) && (X >= PBX2 && X <= PBX2 + 3)) :
    (L2 == 2'd1) ? ((Y == PBY2 - 1 || Y == PBY2 + 1) && (X >= PBX2 && X <= PBX2 + 1)) : 0;
    assign pBullet[3] = (L3 == 2'd3) ? ((Y == PBY3 - 2 || Y == PBY3 - 1 || Y == PBY3 + 1 || Y == PBY3 + 2) && (X >= PBX3 && X <= PBX3 + 2)) :
    (L3 == 2'd2) ? ((Y == PBY3 - 1 || Y == PBY3 + 1) && (X >= PBX3 && X <= PBX3 + 3)) :
    (L3 == 2'd1) ? ((Y == PBY3 - 1 || Y == PBY3 + 1) && (X >= PBX3 && X <= PBX3 + 1)) : 0;
    assign pBullet[4] = (L4 == 2'd3) ? ((Y == PBY4 - 2 || Y == PBY4 - 1 || Y == PBY4 + 1 || Y == PBY4 + 2) && (X >= PBX4 && X <= PBX4 + 2)) :
    (L4 == 2'd2) ? ((Y == PBY4 - 1 || Y == PBY4 + 1) && (X >= PBX4 && X <= PBX4 + 3)) :
    (L4 == 2'd1) ? ((Y == PBY4 - 1 || Y == PBY4 + 1) && (X >= PBX4 && X <= PBX4 + 1)) : 0;
    assign pBullet[5] = (L5 == 2'd3) ? ((Y == PBY5 - 2 || Y == PBY5 - 1 || Y == PBY5 + 1 || Y == PBY5 + 2) && (X >= PBX5 && X <= PBX5 + 2)) :
    (L5 == 2'd2) ? ((Y == PBY5 - 1 || Y == PBY5 + 1) && (X >= PBX5 && X <= PBX5 + 3)) :
    (L5 == 2'd1) ? ((Y == PBY5 - 1 || Y == PBY5 + 1) && (X >= PBX5 && X <= PBX5 + 1)) : 0;
    assign pBullet[6] = (L6 == 2'd3) ? ((Y == PBY6 - 2 || Y == PBY6 - 1 || Y == PBY6 + 1 || Y == PBY6 + 2) && (X >= PBX6 && X <= PBX6 + 2)) :
    (L6 == 2'd2) ? ((Y == PBY6 - 1 || Y == PBY6 + 1) && (X >= PBX6 && X <= PBX6 + 3)) :
    (L6 == 2'd1) ? ((Y == PBY6 - 1 || Y == PBY6 + 1) && (X >= PBX6 && X <= PBX6 + 1)) : 0;
    assign pBullet[7] = (L7 == 2'd3) ? ((Y == PBY7 - 2 || Y == PBY7 - 1 || Y == PBY7 + 1 || Y == PBY7 + 2) && (X >= PBX7 && X <= PBX7 + 2)) :
    (L7 == 2'd2) ? ((Y == PBY7 - 1 || Y == PBY7 + 1) && (X >= PBX7 && X <= PBX7 + 3)) :
    (L7 == 2'd1) ? ((Y == PBY7 - 1 || Y == PBY7 + 1) && (X >= PBX7 && X <= PBX7 + 1)) : 0;
    assign pBullet[8] = (L8 == 2'd3) ? ((Y == PBY8 - 2 || Y == PBY8 - 1 || Y == PBY8 + 1 || Y == PBY8 + 2) && (X >= PBX8 && X <= PBX8 + 2)) :
    (L8 == 2'd2) ? ((Y == PBY8 - 1 || Y == PBY8 + 1) && (X >= PBX8 && X <= PBX8 + 3)) :
    (L8 == 2'd1) ? ((Y == PBY8 - 1 || Y == PBY8 + 1) && (X >= PBX8 && X <= PBX8 + 1)) : 0;
    assign pBullet[9] = (L9 == 2'd3) ? ((Y == PBY9 - 2 || Y == PBY9 - 1 || Y == PBY9 + 1 || Y == PBY9 + 2) && (X >= PBX9 && X <= PBX9 + 2)) :
    (L9 == 2'd2) ? ((Y == PBY9 - 1 || Y == PBY9 + 1) && (X >= PBX9 && X <= PBX9 + 3)) :
    (L9 == 2'd1) ? ((Y == PBY9 - 1 || Y == PBY9 + 1) && (X >= PBX9 && X <= PBX9 + 1)) : 0;
    assign pBeam = (pBeamA) ? (Y <= jet_Y + 2 && Y >= jet_Y - 2) && (X >= jet_X + 6) : 0; 
    assign pBeammarker = (pBeammarkerA) ? (Y == jet_Y && X >= jet_X + 6) : 0;

    wire jet_cockpit;
    wire jet_base;
    wire background;
    
    assign jet_base = (X == jet_X && (Y >= jet_Y - 1 && Y <= jet_Y + 1)) || (Y == jet_Y && (X >= jet_X && X <= jet_X + 5)) || 
    (X == jet_X + 2 && (Y >= jet_Y - 2 && Y <= jet_Y + 2)) || (X == jet_X + 3 && (Y >= jet_Y - 1 && Y <= jet_Y + 1));
    assign jet_cockpit = (Y == jet_Y && (X >= jet_X + 3 && X <= jet_X + 4));
    
    reg halfclock = 0;
    wire enemy_sprite;
    reg [10:0] enemy_hp = 11'd752;
    reg [6:0] enemy_Y = 7'd51;
    reg enemy_pattern;
    wire healthbar;
    wire border;
    wire [15:0] health_col;
    
    assign border = ((X >= 0 && X <= 95) && (Y == 0 || Y == 4)) || ((X == 0 || X == 95) && (Y >= 0 && Y <= 4));
    assign healthbar = (X >= 1 && X <= enemy_hp / 8) && (Y >= 1 && Y <= 3);
    assign health_col = (enemy_hp >= 11'd461) ? 16'h87EA : (enemy_hp >= 11'd230) ? 16'hFFAA : 16'hFA8A;
    
    reg game_over = 0;
    reg game_victory = 0;
    
    assign enemy_sprite = (game_victory) ? 0 : (X >= 7'd83 && X <= 7'd93) && (Y <= enemy_Y && Y >= enemy_Y - 40); 
    
    wire [5:0] D1Bullet;
    reg [5:0] D1_interval = 6'd0;
    reg [6:0] D1X0, D1X1, D1X2, D1X3, D1X4, D1X5;
    reg [6:0] D1Y0, D1Y1, D1Y2, D1Y3, D1Y4, D1Y5;
    reg [5:0] D1A;
    
    assign D1Bullet[0] = D1A[0] ? (Y >= D1Y0 && Y <= D1Y0 + 1) && (X >= D1X0 - 1 && X <= D1X0) : 0;
    assign D1Bullet[1] = D1A[1] ? (Y >= D1Y1 && Y <= D1Y1 + 1) && (X >= D1X1 - 1 && X <= D1X1) : 0;
    assign D1Bullet[2] = D1A[2] ? (Y >= D1Y2 && Y <= D1Y2 + 1) && (X >= D1X2 - 1 && X <= D1X2) : 0;
    assign D1Bullet[3] = D1A[3] ? (Y >= D1Y3 && Y <= D1Y3 + 1) && (X >= D1X3 - 1 && X <= D1X3) : 0;
    assign D1Bullet[4] = D1A[4] ? (Y >= D1Y4 && Y <= D1Y4 + 1) && (X >= D1X4 - 1 && X <= D1X4) : 0;
    assign D1Bullet[5] = D1A[5] ? (Y >= D1Y5 && Y <= D1Y5 + 1) && (X >= D1X5 - 1 && X <= D1X5) : 0;
    
    wire [5:0] D2Bullet;
    reg [5:0] D2_interval;
    reg [6:0] D2X0, D2X1, D2X2, D2X3, D2X4, D2X5;
    reg [6:0] D2Y0, D2Y1, D2Y2, D2Y3, D2Y4, D2Y5;
    reg [5:0] D2A;   

    assign D2Bullet[0] = D2A[0] ? (Y >= D2Y0 - 1 && Y <= D2Y0) && (X >= D2X0 - 1 && X <= D2X0) : 0;
    assign D2Bullet[1] = D2A[1] ? (Y >= D2Y1 - 1 && Y <= D2Y1) && (X >= D2X1 - 1 && X <= D2X1) : 0;
    assign D2Bullet[2] = D2A[2] ? (Y >= D2Y2 - 1 && Y <= D2Y2) && (X >= D2X2 - 1 && X <= D2X2) : 0;
    assign D2Bullet[3] = D2A[3] ? (Y >= D2Y3 - 1 && Y <= D2Y3) && (X >= D2X3 - 1 && X <= D2X3) : 0;
    assign D2Bullet[4] = D2A[4] ? (Y >= D2Y4 - 1 && Y <= D2Y4) && (X >= D2X4 - 1 && X <= D2X4) : 0;
    assign D2Bullet[5] = D2A[5] ? (Y >= D2Y5 - 1 && Y <= D2Y5) && (X >= D2X5 - 1 && X <= D2X5) : 0;
    
    wire [1:0] HBullet;
    reg [7:0] H_interval = 8'd0;
    reg [6:0] HX0, HX1;
    reg [6:0] HY0, HY1;
    reg [1:0] HA;
    
    assign HBullet[0] = HA[0] ? (Y >= HY0 - 1 && Y <= HY0 + 1) && (X >= HX0 - 1 && X <= HX0 + 1) : 0; 
    assign HBullet[1] = HA[1] ? (Y >= HY1 - 1 && Y <= HY1 + 1) && (X >= HX1 - 1 && X <= HX1 + 1) : 0; 
        
    wire [5:0] SBullet;
    reg [5:0] S_interval = 6'd0;
    reg [6:0] SX0, SX1, SX2, SX3, SX4, SX5;
    reg [6:0] SY0, SY1, SY2, SY3, SY4, SY5;
    reg [5:0] SA;

    assign SBullet[0] = SA[0] ? (Y == SY0) && (X >= SX0 - 2 && X <= SX0 + 1) : 0;
    assign SBullet[1] = SA[1] ? (Y == SY1) && (X >= SX1 - 2 && X <= SX1 + 1) : 0;
    assign SBullet[2] = SA[2] ? (Y == SY2) && (X >= SX2 - 2 && X <= SX2 + 1) : 0;
    assign SBullet[3] = SA[3] ? (Y == SY3) && (X >= SX3 - 2 && X <= SX3 + 1) : 0;
    assign SBullet[4] = SA[4] ? (Y == SY4) && (X >= SX4 - 2 && X <= SX4 + 1) : 0;
    assign SBullet[5] = SA[5] ? (Y == SY5) && (X >= SX5 - 2 && X <= SX5 + 1) : 0;
    
    wire [11:0] WBullet;
    reg [7:0] W_interval = 8'd0;
    reg [6:0] WX0, WX1, WX2, WX3, WX4, WX5, WX6, WX7, WX8, WX9, WX10, WX11, WX12;
    reg [6:0] WY0, WY1, WY2, WY3, WY4, WY5, WY6, WY7, WY8, WY9, WY10, WY11, WY12;
    reg [11:0] WA;
    
    assign WBullet[0] = WA[0] ? (Y >= WY0 - 1 && Y <= WY0) && (X >= WX0 - 1 && X <= WX0) : 0;
    assign WBullet[1] = WA[1] ? (Y >= WY1 - 1 && Y <= WY1) && (X >= WX1 - 1 && X <= WX1) : 0;
    assign WBullet[2] = WA[2] ? (Y >= WY2 - 1 && Y <= WY2) && (X >= WX2 - 1 && X <= WX2) : 0;
    assign WBullet[3] = WA[3] ? (Y >= WY3 - 1 && Y <= WY3) && (X >= WX3 - 1 && X <= WX3) : 0;
    assign WBullet[4] = WA[4] ? (Y >= WY4 - 1 && Y <= WY4) && (X >= WX4 - 1 && X <= WX4) : 0;
    assign WBullet[5] = WA[5] ? (Y >= WY5 - 1 && Y <= WY5) && (X >= WX5 - 1 && X <= WX5) : 0;
    assign WBullet[6] = WA[6] ? (Y >= WY6 - 1 && Y <= WY6) && (X >= WX6 - 1 && X <= WX6) : 0;
    assign WBullet[7] = WA[7] ? (Y >= WY7 - 1 && Y <= WY7) && (X >= WX7 - 1 && X <= WX7) : 0;
    assign WBullet[8] = WA[8] ? (Y >= WY8 - 1 && Y <= WY8) && (X >= WX8 - 1 && X <= WX8) : 0;
    assign WBullet[9] = WA[9] ? (Y >= WY9 - 1 && Y <= WY9) && (X >= WX9 - 1 && X <= WX9) : 0;
    assign WBullet[10] = WA[10] ? (Y >= WY10 - 1 && Y <= WY10 + 1) && (X >= WX10 - 1 && X <= WX10) : 0;
    assign WBullet[11] = WA[11] ? (Y >= WY11 - 1 && Y <= WY11 + 1) && (X >= WX11 - 1 && X <= WX11) : 0;
    
    wire beam;
    wire beam_warning;
    reg [8:0] beam_interval = 9'd0;
    wire [6:0] beamY;
    reg beamA;
    reg beam_warningA;
    
    assign beamY = enemy_Y - 20;
    assign beam = beamA ? (Y >= beamY - 3 && Y <= beamY + 3 && X <= 7'd83) : 0;
    assign beam_warning = beam_warningA ? (Y == beamY && X <= 7'd83) : 0;
    
    wire [4:0] random5;
    rng_5bit rng5x(clk, random5);
    
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
        if (secret) begin
            if (pulse_C) begin
                hold_C = 5'b0;
                exit_shooter = 0;
                title_timer = 5'd0;
                jet_Y = 7'd47;
                jet_X = 7'd5;
                enemy_Y = 7'd47;
                L0 = 0;
                L1 = 0;
                L2 = 0;
                L3 = 0;
                L4 = 0;
                L5 = 0;
                L6 = 0;
                L7 = 0;
                L8 = 0;
                L9 = 0;
                D1_interval = 5'd0;
                D1A = 0;
                D2_interval = 5'd0;
                D2A = 0;
                S_interval = 5'd0;
                SA = 0;
                W_interval = 5'd0;
                WA = 0;
                beam_interval = 9'd0;
                H_interval = 8'd0;
                HA = 0;
                pBeamcharges = 1;
                pBombcharges = 1;
                pBeamarm = 0;
                pBombarm = 0;
            end
            if (title_timer == 6'd47 && !game_over) begin
                if (pause) begin
                end      
                else begin
                    bombbg = (bombbg == 5'd0) ? 0 : bombbg - 1;
                    if (toggle_cheat) begin
                        pBombcharges = 1;
                        pBeamcharges = 1;
                    end
                    if (!sw_beam) pBeamarm = 1; 
                    if (!sw_bomb) pBombarm = 1;
                    if (sw_beam && pBeamarm && pBeamcharges) begin
                        pBeam_fire_timer <= (pBeam_fire_timer == 6'd60) ? 0 : pBeam_fire_timer + 1;
                        if (pBeam_fire_timer == 6'd0) pBeammarkerA = 1;
                        if (pBeam_fire_timer == 6'd42) begin
                            pBeamA = 1;
                            pBeammarkerA = 0;
                            pBeamcharges = 0;
                        end
                        if (pBeam_fire_timer == 6'd60) begin
                            pBeamA = 0;
                            pBeamarm = 0;
                            pBeam_fire_timer = 0;
                        end
                    end
                    else begin 
                        pBeam_fire_timer = 0;
                        pBeammarkerA = 0;
                        pBeamA = 0;
                    end
                    if (bombbg != 0) begin
                        SA = 0;
                        D1A = 0;
                        D2A = 0;
                        HA = 0;
                        WA = 0;
                        beamA = 0;
                    end
                    if (sw_bomb && pBombarm && pBombcharges) begin
                        pBombarm = 0;
                        pBombcharges = 0;
                        bombbg = 5'd6;
                    end
                    halfclock = ~halfclock;
                    enemy_pattern = (D1_interval == 6'd48) ? ~enemy_pattern : enemy_pattern; 
                    if (jet_Y < enemy_Y - 40 && halfclock) enemy_Y =  enemy_Y - 1; 
                    if (jet_Y > enemy_Y && halfclock) enemy_Y =  enemy_Y + 1;  
                    if (jet_Y <= enemy_Y && jet_Y >= enemy_Y - 40 & halfclock) enemy_Y = (enemy_Y - 41 > 7'd63 || enemy_Y + 1 > 7'd63) ? enemy_Y : (enemy_pattern) ? enemy_Y + 1 : enemy_Y - 1;                
                    if (PBX0 + 5 >= 7'd95 || hit[0]) L0 = 2'd0;
                    else PBX0 = PBX0 + 5;
                    if (PBX1 + 5 >= 7'd95 || hit[1]) L1 = 2'd0;
                    else PBX1 = PBX1 + 5;
                    if (PBX2 + 5 >= 7'd95 || hit[2]) L2 = 2'd0;
                    else PBX2 = PBX2 + 5;
                    if (PBX3 + 5 >= 7'd95 || hit[3]) L3 = 2'd0;
                    else PBX3 = PBX3 + 5;
                    if (PBX4 + 5 >= 7'd95 || hit[4]) L4 = 2'd0;
                    else PBX4 = PBX4 + 5;
                    if (PBX5 + 5 >= 7'd95 || hit[5]) L5 = 2'd0;
                    else PBX5 = PBX5 + 5;
                    if (PBX6 + 5 >= 7'd95 || hit[6]) L6 = 2'd0;
                    else PBX6 = PBX6 + 5;
                    if (PBX7 + 5 >= 7'd95 || hit[7]) L7 = 2'd0;
                    else PBX7 = PBX7 + 5;
                    if (PBX8 + 5 >= 7'd95 || hit[8]) L8 = 2'd0;
                    else PBX8 = PBX8 + 5;
                    if (PBX9 + 5 >= 7'd95 || hit[9]) L9 = 2'd0;
                    else PBX9 = PBX9 + 5;
                    if (D1X0 - 2 > 7'd95) D1A[0] = 0; //D1 START
                    else D1X0 = D1X0 - 2;
                    if (D1X1 - 2 > 7'd95) D1A[1] = 0;
                    else D1X1 = D1X1 - 2;
                    if (D1Y1 - 1 > 7'd63) D1A[1] = 0;
                    else D1Y1 = D1Y1 - 1;
                    if (D1X2 - 2 > 7'd95) D1A[2] = 0;
                    else D1X2 = D1X2 - 2;
                    if (D1Y2 + 1 > 7'd63) D1A[2] = 0;
                    else D1Y2 = D1Y2 + 1;
                    if (D1X3 - 2 > 7'd95) D1A[3] = 0;
                    else D1X3 = D1X3 - 2;
                    if (D1X4 - 2 > 7'd95) D1A[4] = 0;
                    else D1X4 = D1X4 - 2;
                    if (D1Y4 - 1 > 7'd63) D1A[4] = 0;
                    else D1Y4 = D1Y4 - 1;
                    if (D1X5 - 2 > 7'd95) D1A[5] = 0;
                    else D1X5 = D1X5 - 2;
                    if (D1Y5 + 1 > 7'd63) D1A[5] = 0;
                    else D1Y5 = D1Y5 + 1;
                    if (D2X0 - 2 > 7'd95) D2A[0] = 0; //D2 START
                    else D2X0 = D2X0 - 2;
                    if (D2X1 - 2 > 7'd95) D2A[1] = 0;
                    else D2X1 = D2X1 - 2;
                    if (D2Y1 - 1 > 7'd63) D2A[1] = 0;
                    else D2Y1 = D2Y1 - 1;
                    if (D2X2 - 2 > 7'd95) D2A[2] = 0;
                    else D2X2 = D2X2 - 2;
                    if (D2Y2 + 1 > 7'd63) D2A[2] = 0;
                    else D2Y2 = D2Y2 + 1;
                    if (D2X3 - 2 > 7'd95) D2A[3] = 0;
                    else D2X3 = D2X3 - 2;
                    if (D2X4 - 2 > 7'd95) D2A[4] = 0;
                    else D2X4 = D2X4 - 2;
                    if (D2Y4 - 1 > 7'd63) D2A[4] = 0;
                    else D2Y4 = D2Y4 - 1;
                    if (D2X5 - 2 > 7'd95) D2A[5] = 0;
                    else D2X5 = D2X5 - 2;
                    if (D2Y5 + 1 > 7'd63) D2A[5] = 0;
                    else D2Y5 = D2Y5 + 1;
                    if (SX0 - 3 > 7'd95) SA[0] = 0;
                    else SX0 = SX0 - 3;  
                    if (SX1 - 3 > 7'd95) SA[1] = 0;
                    else SX1 = SX1 - 3;  
                    if (SX2 - 3 > 7'd95) SA[2] = 0;
                    else SX2 = SX2 - 3;  
                    if (SX3 - 3 > 7'd95) SA[3] = 0;
                    else SX3 = SX3 - 3;  
                    if (SX4 - 3 > 7'd95) SA[4] = 0;
                    else SX4 = SX4 - 3;  
                    if (SX5 - 3 > 7'd95) SA[5] = 0;
                    else SX5 = SX5 - 3;  
                    if (WX0 - 2 > 7'd95) WA[0] = 0;
                    else WX0 = WX0 - 2;  
                    if (WX1 - 2 > 7'd95) WA[1] = 0;
                    else WX1 = WX1 - 2;  
                    if (WX2 - 2 > 7'd95) WA[2] = 0;
                    else WX2 = WX2 - 2;  
                    if (WX3 - 2 > 7'd95) WA[3] = 0;
                    else WX3 = WX3 - 2;  
                    if (WX4 - 2 > 7'd95) WA[4] = 0;
                    else WX4 = WX4 - 2;  
                    if (WX5 - 2 > 7'd95) WA[5] = 0;
                    else WX5 = WX5 - 2; 
                    if (WX6 - 2 > 7'd95) WA[6] = 0;
                    else WX6 = WX6 - 2;  
                    if (WX7 - 2 > 7'd95) WA[7] = 0;
                    else WX7 = WX7 - 2;  
                    if (WX8 - 2 > 7'd95) WA[8] = 0;
                    else WX8 = WX8 - 2;  
                    if (WX9 - 2 > 7'd95) WA[9] = 0;
                    else WX9 = WX9 - 2;  
                    if (WX10 - 2 > 7'd95) WA[10] = 0;
                    else WX10 = WX10 - 2;  
                    if (WX11 - 2 > 7'd95) WA[11] = 0;
                    else WX11 = WX11 - 2; 
                    if (HX0 - 1 > 7'd95 && halfclock) HA[0] = 0;
                    else HX0 = HX0 - 1;
                    if (HX1 - 1 > 7'd95 && halfclock) HA[1] = 0;
                    else HX1 = HX1 - 1;
                    if (HY0 < jet_Y && halfclock) HY0 = HY0 + 1;
                    if (HY0 > jet_Y && halfclock) HY0 = HY0 - 1;
                    if (HY1 < jet_Y && halfclock) HY1 = HY1 + 1;
                    if (HY1 > jet_Y && halfclock) HY1 = HY1 - 1;
                    D1_interval <= (D1_interval == 6'd48) ? 0 : D1_interval + 1;
                    if (D1_interval == 6'd24) begin
                        D1A[2:0] = 3'b111;
                        D1X0 = 7'd83; D1X1 = 7'd83; D1X2 = 7'd83;
                        D1Y0 = enemy_Y - 30; D1Y1 =  enemy_Y - 30; D1Y2 = enemy_Y - 30;
                    end
                    if (D1_interval == 6'd48) begin
                        D1A[5:3] = 3'b111;
                        D1X3 = 7'd83; D1X4 = 7'd83; D1X5 = 7'd83;
                        D1Y3 = enemy_Y - 30; D1Y4 = enemy_Y - 30; D1Y5 = enemy_Y - 30;
                    end
                    D2_interval <= (D2_interval == 6'd48) ? 0 : D2_interval + 1;
                    if (D2_interval == 6'd12) begin
                        D2A[2:0] = 3'b111;
                        D2X0 = 7'd83; D2X1 = 7'd83; D2X2 = 7'd83;
                        D2Y0 = enemy_Y - 10; D2Y1 =  enemy_Y - 10; D2Y2 =  enemy_Y - 10;
                    end   
                    if (D2_interval == 6'd36) begin
                        D2A[5:3] = 3'b111;
                        D2X3 = 7'd83; D2X4 = 7'd83; D2X5 = 7'd83; 
                        D2Y3 = enemy_Y - 10; D2Y4 = enemy_Y - 10; D2Y5 = enemy_Y - 10;
                    end                
                    S_interval <= (S_interval == 6'd36) ? 0 : S_interval + 1;
                    if (S_interval == 6'd6 ) begin
                        SA[0] = 1;
                        SX0 = 7'd83;
                        SY0 = enemy_Y - 4 - random5;
                    end
                    if (S_interval == 6'd12) begin
                        SA[1] = 1;
                        SX1 = 7'd83;
                        SY1 = enemy_Y - 4 - random5;
                    end
                    if (S_interval == 6'd18) begin
                        SA[2] = 1;
                        SX2 = 7'd83;
                        SY2 = enemy_Y - 4 - random5;
                    end
                    if (S_interval == 6'd24) begin
                        SA[3] = 1;
                        SX3 = 7'd83;
                        SY3 = enemy_Y - 4 - random5;
                    end
                    if (S_interval == 6'd30) begin
                        SA[4] = 1;
                        SX4 = 7'd83;
                        SY4 = enemy_Y - 4 - random5;
                    end
                    if (S_interval == 6'd36) begin
                        SA[5] = 1;
                        SX5 = 7'd83;
                        SY5 = enemy_Y - 4 - random5;
                    end              
                    if (!toggle_mode) begin
                        H_interval <= (H_interval == 8'd144) ? 0 : H_interval + 1;
                            if (H_interval == 8'd72) begin
                                HA[0] = 1;
                                HX0 = 7'd83;
                                HY0 = enemy_Y - 5;
                            end   
                            if (H_interval == 8'd144) begin
                                HA[1] = 1;
                                HX1 = 7'd83; 
                                HY1 = enemy_Y - 35; 
                            end    
                        W_interval <= (W_interval == 8'd240) ? 0 : W_interval + 1;
                        if (W_interval == 8'd192) begin
                            WA[3:0] = 4'b1111;
                            WX0 = 7'd83; WX1 = 7'd83; WX2 = 7'd83; WX3 = 7'd83; 
                            WY0 = enemy_Y; WY1 = enemy_Y - 13; WY2 = enemy_Y - 27; WY3 = enemy_Y - 40;
                        end
                        if (W_interval == 8'd216) begin
                            WA[7:4] = 4'b1111;
                            WX4 = 7'd83; WX5 = 7'd83; WX6 = 7'd83; WX7 = 7'd83; 
                            WY4 = enemy_Y - 6; WY5 = enemy_Y - 15; WY6 = enemy_Y - 23; WY7 = enemy_Y - 34;
                        end
                        if (W_interval == 8'd240) begin
                            WA[11:8] = 4'b1111;
                            WX8 = 7'd83; WX9 = 7'd83; WX10 = 7'd83; WX11 = 7'd83; 
                            WY8 = enemy_Y; WY9 = enemy_Y - 13; WY10 = enemy_Y - 27; WY11 = enemy_Y - 40;
                        end
                        beam_interval <= (beam_interval == 9'd384) ? 0 : beam_interval + 1;
                        if (beam_interval == 9'd312) beam_warningA = 1;
                        if (beam_interval == 9'd360) begin
                            beam_warningA = 0;
                            beamA = 1;
                        end
                        if (beam_interval == 9'd0) beamA = 0;
                    end
                    if (toggle_mode) begin
                        W_interval = 0;
                        beam_interval = 0;
                    end
                    if (pBeam_fire_timer == 6'd0) begin
                        jet_fire_timer <= (jet_fire_timer == 5'd20) ? 0 : jet_fire_timer + 1; 
                        if (jet_fire_timer == 5'd2) begin
                            L0 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX0 = jet_X;
                            PBY0 = jet_Y;
                        end
                        if (jet_fire_timer == 5'd4) begin
                            L1 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX1 = jet_X;
                            PBY1 = jet_Y;
                        end
                        if (jet_fire_timer == 5'd6) begin
                            L2 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX2 = jet_X;
                            PBY2 = jet_Y;
                        end
                        if (jet_fire_timer == 5'd8) begin
                            L3 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX3 = jet_X;
                            PBY3 = jet_Y;
                        end
                        if (jet_fire_timer == 5'd10) begin
                            L4 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX4 = jet_X;
                            PBY4 = jet_Y;
                        end
                        if (jet_fire_timer == 5'd12) begin
                            L5 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX5 = jet_X;
                            PBY5 = jet_Y;
                        end
                        if (jet_fire_timer == 5'd14) begin
                            L6 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX6 = jet_X;
                            PBY6 = jet_Y;
                        end
                        if (jet_fire_timer == 5'd16) begin
                            L7 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX7 = jet_X;
                            PBY7 = jet_Y;
                        end
                        if (jet_fire_timer == 5'd18) begin
                            L8 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX8 = jet_X;
                            PBY8 = jet_Y;
                        end
                        if (jet_fire_timer == 5'd20) begin
                            L9 = (volume24 >= 16'd65535) ? 2'd3 : (volume24 >= 16'd511) ? 2'd2 : 2'd1;
                            PBX9 = jet_X;
                            PBY9 = jet_Y;
                        end
                    end
                    if (btnU && jet_Y - 2 >= 7'd4) jet_Y = jet_Y - 2;
                    if (btnD && jet_Y + 2 <= 7'd63) jet_Y = jet_Y + 2;
                    if (btnL && jet_X - 1 <= 7'd95) jet_X = jet_X - 1;
                    if (btnR && jet_X + 2 <= 7'd95) jet_X = jet_X + 2; 
                end
            end
            title_timer <= (title_timer == 6'd47) ? 6'd47 : title_timer + 1;
            hold_C <= (btnC) ? (hold_C == 5'd23) ? 5'd23 : hold_C + 1 : 0;
            if (hold_C == 5'd23) exit_shooter = 1;
        end
        else begin
            hold_C = 5'b0;
            exit_shooter = 0;
            title_timer = 5'd0;
            jet_Y = 7'd47;
            jet_X = 7'd5;
            enemy_Y = 7'd47;
            L0 = 0;
            L1 = 0;
            L2 = 0;
            L3 = 0;
            L4 = 0;
            L5 = 0;
            L6 = 0;
            L7 = 0;
            L8 = 0;
            L9 = 0;
            D1_interval = 5'd0;
            D1A = 0;
            D2_interval = 5'd0;
            D2A = 0;
            S_interval = 5'd0;
            SA = 0;
            W_interval = 5'd0;
            WA = 0;
            beam_interval = 9'd0;
            H_interval = 8'd0;
            HA = 0;
            pBeamcharges = 1;
            pBombcharges = 1;
            pBeamarm = 0;
            pBombarm = 0;
        end
    end
    
    always@(posedge clk) begin      
        if (secret) begin
            if (pulse_C) begin
                game_over = 0;    
                game_victory = 0;
                enemy_hp = 11'd768;              
            end
            if (pBullet[0] && enemy_sprite && hit[0] == 0) begin
                enemy_hp = enemy_hp - (L0 << 1);
                hit[0] = 1;
            end
            if (pBullet[1] && enemy_sprite && hit[1] == 0) begin
                enemy_hp = enemy_hp - (L1 << 1);
                hit[1] = 1;
            end
            if (pBullet[2] && enemy_sprite && hit[2] == 0) begin
                enemy_hp = enemy_hp - (L2 << 1);
                hit[2] = 1;
            end
            if (pBullet[3] && enemy_sprite && hit[3] == 0) begin
                enemy_hp = enemy_hp - (L3 << 1);
                hit[3] = 1;
            end
            if (pBullet[4] && enemy_sprite && hit[4] == 0) begin
                enemy_hp = enemy_hp - (L4 << 2);
                hit[4] = 1;
            end
            if (pBullet[5] && enemy_sprite && hit[5] == 0) begin
                enemy_hp = enemy_hp - (L5 << 1);
                hit[5] = 1;
            end
            if (pBullet[6] && enemy_sprite && hit[6] == 0) begin
                enemy_hp = enemy_hp - (L6 << 1);
                hit[6] = 1;
            end
            if (pBullet[7] && enemy_sprite && hit[7] == 0) begin
                enemy_hp = enemy_hp - (L7 << 1);
                hit[7] = 1;
            end
            if (pBullet[8] && enemy_sprite && hit[8] == 0) begin
                enemy_hp = enemy_hp - (L8 << 1);
                hit[8] = 1;
            end
            if (pBullet[9] && enemy_sprite && hit[9] == 0) begin
                enemy_hp = enemy_hp - (L9 << 1);
                hit[9] = 1;
            end
            if (pBeam && enemy_sprite && !hitbeam) begin
                hitbeam = 1;
                enemy_hp = enemy_hp - 9'd250;
            end
            if (jet_base && (D1Bullet || D2Bullet || SBullet || HBullet || WBullet || beam || enemy_sprite) && !toggle_cheat) game_over = 1;
            hit[0] = (jet_fire_timer == 5'd0) ? 0 : hit[0];
            hit[1] = (jet_fire_timer == 5'd2) ? 0 : hit[1];
            hit[2] = (jet_fire_timer == 5'd4) ? 0 : hit[2];
            hit[3] = (jet_fire_timer == 5'd6) ? 0 : hit[3];
            hit[4] = (jet_fire_timer == 5'd8) ? 0 : hit[4];
            hit[5] = (jet_fire_timer == 5'd10) ? 0 : hit[5];
            hit[6] = (jet_fire_timer == 5'd12) ? 0 : hit[6];
            hit[7] = (jet_fire_timer == 5'd14) ? 0 : hit[7];
            hit[8] = (jet_fire_timer == 5'd16) ? 0 : hit[8];
            hit[9] = (jet_fire_timer == 5'd18) ? 0 : hit[9];
            if (pBeam_fire_timer == 6'd41) hitbeam = 0; 
            if (enemy_hp == 0 || enemy_hp > 768) game_victory = 1; 
            oled_title = shooter_title[pixel_index];
            oled_gameover = shooter_gameover[pixel_index]; 
            oled_victory = shooter_victory[pixel_index];
            oled_game = (border) ? 16'h0000 : (pause_text) ? 16'hE861 : (healthbar) ? health_col : (beam_warning || pBeammarker) ? 16'hF800 : (beam || pBeam) ? 16'hF29F : (HBullet) ? 16'h7810 : (SBullet) ?  16'h003F : (WBullet) ? 16'h17E0 : (D1Bullet || D2Bullet) ? 16'hF800 : (pBullet) ? 16'hFD60 : (enemy_sprite) ? 16'h4A49 : (jet_cockpit) ? 16'hFFEC : (jet_base) ? 16'h738E : (bombbg != 0) ? 16'hE5C6 : 16'h87FF;
            oled_shooter = (title_timer == 6'd47) ? (game_victory) ? oled_victory : (game_over) ? oled_gameover : oled_game : oled_title;
            //sbullet blue wbulletgreen dbullet red
        end
        else begin           
            game_over = 0;    
            game_victory = 0;
            enemy_hp = 11'd752;              
        end
    end       
    
endmodule

