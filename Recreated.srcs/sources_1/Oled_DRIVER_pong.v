`timescale 1ns / 1ps

module Oled_DRIVER_pong(input clk, input clk24, input pause, input [15:0] volume24, input btnL, input btnR, input btnC, input [6:0] X, input [6:0] Y, 
input [12:0] pixel_index, output reg [15:0] oled_PONG, output reg exit_pong = 0, input [1:0] display_flag);

    // Exit
    reg [4:0] hold_C = 5'd0;
    
    // Game elements
    wire player1;
    wire player1_edge_L;
    wire player1_edge_R;
    reg [7:0] player1_X;
    
    wire player2_edge_L;
    wire player2_edge_R;
    wire player2;
    reg [7:0] player2_X;
    
    wire ball;
    reg [7:0] ball_X;
    reg [7:0] ball_Y;
    reg [15:0] oled_title;
    reg [15:0] oled_gameover;
    reg [15:0] oled_win;
    reg [15:0] oled_game;
    reg game_over = 0;
    reg win = 0;
    
    reg moveBall_X = 0;
    reg moveBall_X_L_fast = 0;
    reg moveBall_X_R_fast = 0;
    reg moveBall_Y = 0;
    reg hit = 1;
    reg hit_side = 1;
    
    // Title elements
    wire pong_title;
    reg [15:0] pong_lose[6143:0];    
    reg [15:0] pong_win[6143:0];
    reg [5:0] title_timer = 6'd0;
    
    initial begin
        $readmemh("pong-win.mem", pong_win);
        $readmemh("spongebob.mem", pong_lose);
    end
    
    assign pong_title = ((X >= 9 && X <= 24) && (Y >= 22 && Y <= 41) && !((X >= 13 && X <= 20) && (Y >= 26 && Y <= 29)) && !((X >= 13 && X <= 24) && (Y >= 34 && Y <= 41))) ||
        ((X >= 29 && X <= 44) && (Y >= 22 && Y <= 41) && !((X >= 33 && X <= 40) && (Y >= 26 && Y <= 37))) ||
        (((X >= 49 && X <= 52 || X >= 61 && X <= 64) && (Y >= 22 && Y <= 41)) || ((X >= 53 && X <= 56) && (Y >= 26 && Y <= 29)) || ((X >= 57 && X <= 60) && (Y >= 30 && Y <= 33))) ||
        (((X >= 69 && X <= 84) && (Y >= 22 && Y <= 41)) && !((X >= 73 && X <= 84) && (Y >= 26 && Y <= 29)) && !((X >= 73 && X <= 76) && (Y >= 30 && Y <= 33)) &&
        !((X >= 73 && X <= 80) && (Y >= 34 && Y <= 37)));
    
    wire pause_text;
    wire pulse_C;
    debounced_button DB_C(clk24, btnC, pulse_C);
    
    assign pause_text = (pause) ? ((X >= 4 && X <= 7) && (Y >= 16 && Y <= 45)) || (((Y >= 16 && Y <= 31) && (X >= 4 && X <= 19))
    && !((Y >= 20 && Y <= 27) && (X >= 8 && X <= 15))) || //P
    (((X >= 22 && X <= 37) && (Y >= 16 && Y <= 45)) && !((Y >= 20 && Y <= 27) && (X >= 26 && X <= 33)) &&
    !((Y >= 32 && Y <= 45) && (X >= 26 && X <= 33))) || //A
    ((X >= 40 && X <= 55) && (Y >= 16 && Y <= 45) && !(X >= 44 && X <= 51 && Y >= 16 && Y <= 41)) || //U
    ((X >= 58 && X <= 73) && (Y >= 16 && Y <= 45) && !(X >= 62 && X <= 73 && Y >= 20 && Y <= 28) &&
    !(X >= 58 && X <= 69 && Y >= 33 && Y <= 41)) || //S
    ((X >= 76 && X <= 91) && (Y >= 16 && Y <= 45)) && !(X >= 80 && X <= 91 && ((Y >= 20 && Y <= 28) ||
    (Y >= 33 && Y <= 41))) : 0; //E 
    
    assign player1_edge_L = (Y >= 57 && Y <= 60) && (X >= player1_X - 10 && X <= player1_X - 7);
    assign player1_edge_R = (Y >= 57 && Y <= 60) && (X >= player1_X + 6 && X <= player1_X + 10);
    assign player1 = (Y >= 57 && Y <= 60) && (X >= player1_X - 6 && X <= player1_X + 5);
    
    assign player2_edge_L = (Y >= 4 && Y <= 7) && (X >= player2_X - 10 && X <= player2_X - 7);
    assign player2_edge_R = (Y >= 4 && Y <= 7) && (X >= player2_X + 6 && X <= player2_X + 10);
    assign player2 = (Y >= 4 && Y <= 7) && (X >= player2_X - 6 && X <= player2_X + 5);
    
    assign ball = (Y >= ball_Y - 1 && Y <= ball_Y + 1) && (X >= ball_X - 1 && X <= ball_X + 1);
    
    always@(posedge clk24) begin
        if (display_flag == 3'd2) begin
            if (pulse_C) begin
                hold_C = 5'b0;
                exit_pong = 0;
                title_timer = 5'd0;
                ball_X = 7'd47;
                ball_Y = 7'd31;   
                player1_X = 7'd47;
                player2_X = 7'd47;
            end
            if (title_timer == 6'd47 && !game_over) begin      
                if (pause) begin
                end
                else begin
                    // Player 1 (USER) Controls
                    if (player1_X > 7'd11 && btnL) player1_X = player1_X - 1;
                    if (player1_X < 7'd85 && btnR) player1_X = player1_X + 1;
                    // AI Generated Controls
                    if (player2_X < 7'd85 && player2_X < ball_X) player2_X = player2_X + 1;
                    if (player2_X > 7'd11 && player2_X > ball_X) player2_X = player2_X - 1;
                    // Ball movements
                    if (moveBall_X) begin
                        ball_X = (moveBall_X_L_fast) ? ball_X + 2 : ball_X + 1;
                    end else begin
                        ball_X = (moveBall_X_R_fast) ? ball_X - 2 : ball_X - 1;
                    end
                    ball_Y = (moveBall_Y) ? ball_Y + 1 : (volume24 >= 16'd511) ? ball_Y - 3 : ball_Y - 1; 
                end
            end
            title_timer <= (title_timer == 6'd47) ? 6'd47 : title_timer + 1;
            hold_C <= (btnC) ? (hold_C == 5'd23) ? 5'd23 : hold_C + 1 : 0;
            if (hold_C == 5'd23) exit_pong = 1;
        end
        else begin
            hold_C = 5'b0;
            exit_pong = 0;
            title_timer = 5'd0;
            ball_X = 7'd47;
            ball_Y = 7'd31;   
            player1_X = 7'd47;
            player2_X = 7'd47;
        end
    end
    
    
    always@(posedge clk) begin      
        if (display_flag == 3'd2) begin
            if (pulse_C) begin
                game_over = 0;
                win = 0;
                hit = 1;
                hit_side = 1;
                moveBall_Y = 0;
                moveBall_X = 0;
                moveBall_X_L_fast = 0;
                moveBall_X_R_fast = 0;
            end
            oled_title = (pong_title) ? 16'hffff : 16'h0000;
            oled_gameover = pong_lose[pixel_index];
            oled_win = pong_win[pixel_index];
            oled_game = (pause_text) ? 16'hE861 : (player1 || player2 || ball) ? 16'hffff : (player1_edge_L || player1_edge_R || player2_edge_L || player2_edge_R) ? 16'hf783 : 16'h0000;
            oled_PONG = (title_timer == 6'd47) ? (game_over) ? oled_gameover : (win) ? oled_win : oled_game : oled_title;
            if (ball_Y <= 2 && hit) begin
                win = 1;
            end
            else if (ball_Y >= 61 && !hit) begin
                game_over = 1;
            end
            if ((ball_X == 0 || ball_X > 115) && hit_side || ball_X >= 95 && !hit_side) begin
                moveBall_X = ~moveBall_X;
                
                hit_side = ~hit_side;
            end
            
            if ((ball && player1_edge_L && !hit) || (ball && player2_edge_L && hit)) begin
                moveBall_Y = ~moveBall_Y;
                moveBall_X_L_fast = 1;
                hit = ~hit;
            end
            
            if ((ball && player1_edge_R && !hit) || (ball && player2_edge_R && hit)) begin
                moveBall_Y = ~moveBall_Y;
                moveBall_X_R_fast = 1;
                hit = ~hit;
            end
            
            if ((ball && player1 && !hit) || (ball && player2 && hit)) begin
                moveBall_Y = ~moveBall_Y;
                moveBall_X_L_fast = 0;
                moveBall_X_R_fast = 0;
                hit = ~hit;
            end   
        end
        else begin    
            game_over = 0;
            win = 0;
            hit = 1;
            hit_side = 1;
            moveBall_Y = 0;
            moveBall_X = 0;
            moveBall_X_L_fast = 0;
            moveBall_X_R_fast = 0;
        end
    end

endmodule
