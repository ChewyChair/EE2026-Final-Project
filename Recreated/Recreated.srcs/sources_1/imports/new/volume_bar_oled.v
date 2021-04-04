`timescale 1ns / 1ps

module volume_bar_oled(input [1:0] toggle_color, input show_bar, input btnL, input btnR, input btnC, input btnU,
input btnD, input clk24, input [15:0] bg_col, input [1:0] border_width, input [15:0] volume10, input [15:0] volume24, input [6:0] X, 
input [6:0] Y, output reg [15:0] bar_data, output reg exit_AUDVIS = 0, input [2:0] display_flag, input toggle_mode);

    reg [6:0] bar_pos = 7'd47;
    reg [5:0] bar_width = 6'd6;
    wire bar_range;
    assign bar_range = (X >= (bar_pos - bar_width) && X <= (bar_pos + 1 + bar_width));
    
    wire [15:0] low_col; 
    wire [15:0] med_col;
    wire [15:0] hi_col; 
    wire [15:0] bar;
    
    assign low_col = (toggle_color == 2'b11) ? 16'h78B5 :
                     (toggle_color == 2'b10) ? 16'h2367 :
                     (toggle_color == 2'b01) ? 16'h12D1 : 
                     16'h47E5;
    assign med_col = (toggle_color == 2'b11) ? 16'hA1DB :
                     (toggle_color == 2'b10) ? 16'h2EA9 :
                     (toggle_color == 2'b01) ? 16'h253A : 
                     16'hE7E5;
    assign hi_col = (toggle_color == 2'b11) ? 16'hD39F :
                    (toggle_color == 2'b10) ? 16'h97F5 :
                    (toggle_color == 2'b01) ? 16'h7FFF : 
                    16'hF965; 
    
    assign bar[0] = (volume10 >= 16'd1 && Y >= 58 && Y <= 59);
    assign bar[1] = (volume10 >= 16'd3 && Y >= 55 && Y <= 56);
    assign bar[2] = (volume10 >= 16'd7 && Y >= 52 && Y <= 53);
    assign bar[3] = (volume10 >= 16'd15 && Y >= 49 && Y <= 50);
    assign bar[4] = (volume10 >= 16'd31 && Y >= 46 && Y <= 47);
    assign bar[5] = (volume10 >= 16'd63 && Y >= 43 && Y <= 44);
    assign bar[6] = (volume10 >= 16'd127 && Y >= 39 && Y <= 41);
    assign bar[7] = (volume10 >= 16'd255 && Y >= 35 && Y <= 37);
    assign bar[8] = (volume10 >= 16'd511 && Y >= 31 && Y <= 33);
    assign bar[9] = (volume10 >= 16'd1023 && Y >= 27 && Y <= 29);
    assign bar[10] = (volume10 >= 16'd2047 && Y >= 24 && Y <= 25);
    assign bar[11] = (volume10 >= 16'd4095 && Y >= 20 && Y <= 22);
    assign bar[12] = (volume10 >= 16'd8191 && Y >= 16 && Y <= 18);
    assign bar[13] = (volume10 >= 16'd16383 && Y >= 12 && Y <= 14);
    assign bar[14] = (volume10 >= 16'd32767 && Y >= 8 && Y <= 10);
    assign bar[15] = (volume10 >= 16'd65535 && Y >= 4 && Y <= 6); 

    wire pulse_L;
    wire pulse_R; 
    wire pulse_U;
    wire pulse_D;
    wire pulse_C;
    reg [4:0] hold_L = 5'd0;
    reg [4:0] hold_R = 5'd0;
    reg [4:0] hold_U = 5'd0;
    reg [4:0] hold_D = 5'd0;
    reg [4:0] hold_C = 5'd0;
    debounced_button DB_L(clk24, btnL, pulse_L);
    debounced_button DB_R(clk24, btnR, pulse_R);
    debounced_button DB_U(clk24, btnU, pulse_U);
    debounced_button DB_D(clk24, btnD, pulse_D);
    debounced_button DB_C(clk24, btnC, pulse_C);

    wire [7:0] pos;
    wire [15:0] bar0, bar1, bar2, bar3, bar4, bar5, bar6, bar7;
    reg [15:0] vol0, vol1, vol2, vol3, vol4, vol5, vol6, vol7;
    
    assign pos[0] = (X >= 4 && X <= 13);
    assign pos[1] = (X >= 15 && X <= 24);
    assign pos[2] = (X >= 26 && X <= 35);
    assign pos[3] = (X >= 37 && X <= 46);
    assign pos[4] = (X >= 48 && X <= 58);
    assign pos[5] = (X >= 60 && X <= 69);
    assign pos[6] = (X >= 71 && X <= 80);
    assign pos[7] = (X >= 82 && X <= 91);
    
    assign bar0 = {(vol0 >= 16'd1 && Y >= 58 && Y <= 59), (vol0 >= 16'd3 && Y >= 55 && Y <= 56), (vol0 >= 16'd7 && Y >= 52 && Y <= 53), (vol0 >= 16'd15 && Y >= 49 && Y <= 50),
    (vol0 >= 16'd31 && Y >= 46 && Y <= 47), (vol0 >= 16'd63 && Y >= 43 && Y <= 44), (vol0 >= 16'd127 && Y >= 39 && Y <= 41), (vol0 >= 16'd255 && Y >= 35 && Y <= 37),
    (vol0 >= 16'd511 && Y >= 31 && Y <= 33), (vol0 >= 16'd1023 && Y >= 27 && Y <= 29), (vol0 >= 16'd2047 && Y >= 24 && Y <= 25), (vol0 >= 16'd4095 && Y >= 20 && Y <= 22),
    (vol0 >= 16'd8191 && Y >= 16 && Y <= 18), (vol0 >= 16'd16383 && Y >= 12 && Y <= 14), (vol0 >= 16'd32767 && Y >= 8 && Y <= 10), (vol0 >= 16'd65535 && Y >= 4 && Y <= 6)}; 
    
    assign bar1 = {(vol1 >= 16'd1 && Y >= 58 && Y <= 59), (vol1 >= 16'd3 && Y >= 55 && Y <= 56), (vol1 >= 16'd7 && Y >= 52 && Y <= 53), (vol1 >= 16'd15 && Y >= 49 && Y <= 50),
    (vol1 >= 16'd31 && Y >= 46 && Y <= 47), (vol1 >= 16'd63 && Y >= 43 && Y <= 44), (vol1 >= 16'd127 && Y >= 39 && Y <= 41), (vol1 >= 16'd255 && Y >= 35 && Y <= 37),
    (vol1 >= 16'd511 && Y >= 31 && Y <= 33), (vol1 >= 16'd1023 && Y >= 27 && Y <= 29), (vol1 >= 16'd2047 && Y >= 24 && Y <= 25), (vol1 >= 16'd4095 && Y >= 20 && Y <= 22),
    (vol1 >= 16'd8191 && Y >= 16 && Y <= 18), (vol1 >= 16'd16383 && Y >= 12 && Y <= 14), (vol1 >= 16'd32767 && Y >= 8 && Y <= 10), (vol1 >= 16'd65535 && Y >= 4 && Y <= 6)};
    
    assign bar2 = {(vol2 >= 16'd1 && Y >= 58 && Y <= 59), (vol2 >= 16'd3 && Y >= 55 && Y <= 56), (vol2 >= 16'd7 && Y >= 52 && Y <= 53), (vol2 >= 16'd15 && Y >= 49 && Y <= 50),
    (vol2 >= 16'd31 && Y >= 46 && Y <= 47), (vol2 >= 16'd63 && Y >= 43 && Y <= 44), (vol2 >= 16'd127 && Y >= 39 && Y <= 41), (vol2 >= 16'd255 && Y >= 35 && Y <= 37),
    (vol2 >= 16'd511 && Y >= 31 && Y <= 33), (vol2 >= 16'd1023 && Y >= 27 && Y <= 29), (vol2 >= 16'd2047 && Y >= 24 && Y <= 25), (vol2 >= 16'd4095 && Y >= 20 && Y <= 22),
    (vol2 >= 16'd8191 && Y >= 16 && Y <= 18), (vol2 >= 16'd16383 && Y >= 12 && Y <= 14), (vol2 >= 16'd32767 && Y >= 8 && Y <= 10), (vol2 >= 16'd65535 && Y >= 4 && Y <= 6)}; 
    
    assign bar3 = {(vol3 >= 16'd1 && Y >= 58 && Y <= 59), (vol3 >= 16'd3 && Y >= 55 && Y <= 56), (vol3 >= 16'd7 && Y >= 52 && Y <= 53), (vol3 >= 16'd15 && Y >= 49 && Y <= 50),
    (vol3 >= 16'd31 && Y >= 46 && Y <= 47), (vol3 >= 16'd63 && Y >= 43 && Y <= 44), (vol3 >= 16'd127 && Y >= 39 && Y <= 41), (vol3 >= 16'd255 && Y >= 35 && Y <= 37),
    (vol3 >= 16'd511 && Y >= 31 && Y <= 33), (vol3 >= 16'd1023 && Y >= 27 && Y <= 29), (vol3 >= 16'd2047 && Y >= 24 && Y <= 25), (vol3 >= 16'd4095 && Y >= 20 && Y <= 22),
    (vol3 >= 16'd8191 && Y >= 16 && Y <= 18), (vol3 >= 16'd16383 && Y >= 12 && Y <= 14), (vol3 >= 16'd32767 && Y >= 8 && Y <= 10), (vol3 >= 16'd65535 && Y >= 4 && Y <= 6)};
    
    assign bar4 = {(vol4 >= 16'd1 && Y >= 58 && Y <= 59), (vol4 >= 16'd3 && Y >= 55 && Y <= 56), (vol4 >= 16'd7 && Y >= 52 && Y <= 53), (vol4 >= 16'd15 && Y >= 49 && Y <= 50),
    (vol4 >= 16'd31 && Y >= 46 && Y <= 47), (vol4 >= 16'd63 && Y >= 43 && Y <= 44), (vol4 >= 16'd127 && Y >= 39 && Y <= 41), (vol4 >= 16'd255 && Y >= 35 && Y <= 37),
    (vol4 >= 16'd511 && Y >= 31 && Y <= 33), (vol4 >= 16'd1023 && Y >= 27 && Y <= 29), (vol4 >= 16'd2047 && Y >= 24 && Y <= 25), (vol4 >= 16'd4095 && Y >= 20 && Y <= 22),
    (vol4 >= 16'd8191 && Y >= 16 && Y <= 18), (vol4 >= 16'd16383 && Y >= 12 && Y <= 14), (vol4 >= 16'd32767 && Y >= 8 && Y <= 10), (vol4 >= 16'd65535 && Y >= 4 && Y <= 6)};
    
    assign bar5 = {(vol5 >= 16'd1 && Y >= 58 && Y <= 59), (vol5 >= 16'd3 && Y >= 55 && Y <= 56), (vol5 >= 16'd7 && Y >= 52 && Y <= 53), (vol5 >= 16'd15 && Y >= 49 && Y <= 50),
    (vol5 >= 16'd31 && Y >= 46 && Y <= 47), (vol5 >= 16'd63 && Y >= 43 && Y <= 44), (vol5 >= 16'd127 && Y >= 39 && Y <= 41), (vol5 >= 16'd255 && Y >= 35 && Y <= 37),
    (vol5 >= 16'd511 && Y >= 31 && Y <= 33), (vol5 >= 16'd1023 && Y >= 27 && Y <= 29), (vol5 >= 16'd2047 && Y >= 24 && Y <= 25), (vol5 >= 16'd4095 && Y >= 20 && Y <= 22),
    (vol5 >= 16'd8191 && Y >= 16 && Y <= 18), (vol5 >= 16'd16383 && Y >= 12 && Y <= 14), (vol5 >= 16'd32767 && Y >= 8 && Y <= 10), (vol5 >= 16'd65535 && Y >= 4 && Y <= 6)}; 
    
    assign bar6 = {(vol6 >= 16'd1 && Y >= 58 && Y <= 59), (vol6 >= 16'd3 && Y >= 55 && Y <= 56), (vol6 >= 16'd7 && Y >= 52 && Y <= 53), (vol6 >= 16'd15 && Y >= 49 && Y <= 50),
    (vol6 >= 16'd31 && Y >= 46 && Y <= 47), (vol6 >= 16'd63 && Y >= 43 && Y <= 44), (vol6 >= 16'd127 && Y >= 39 && Y <= 41), (vol6 >= 16'd255 && Y >= 35 && Y <= 37),
    (vol6 >= 16'd511 && Y >= 31 && Y <= 33), (vol6 >= 16'd1023 && Y >= 27 && Y <= 29), (vol6 >= 16'd2047 && Y >= 24 && Y <= 25), (vol6 >= 16'd4095 && Y >= 20 && Y <= 22),
    (vol6 >= 16'd8191 && Y >= 16 && Y <= 18), (vol6 >= 16'd16383 && Y >= 12 && Y <= 14), (vol6 >= 16'd32767 && Y >= 8 && Y <= 10), (vol6 >= 16'd65535 && Y >= 4 && Y <= 6)};
    
    assign bar7 = {(vol7 >= 16'd1 && Y >= 58 && Y <= 59), (vol7 >= 16'd3 && Y >= 55 && Y <= 56), (vol7 >= 16'd7 && Y >= 52 && Y <= 53), (vol7 >= 16'd15 && Y >= 49 && Y <= 50),
    (vol7 >= 16'd31 && Y >= 46 && Y <= 47), (vol7 >= 16'd63 && Y >= 43 && Y <= 44), (vol7 >= 16'd127 && Y >= 39 && Y <= 41), (vol7 >= 16'd255 && Y >= 35 && Y <= 37),
    (vol7 >= 16'd511 && Y >= 31 && Y <= 33), (vol7 >= 16'd1023 && Y >= 27 && Y <= 29), (vol7 >= 16'd2047 && Y >= 24 && Y <= 25), (vol7 >= 16'd4095 && Y >= 20 && Y <= 22),
    (vol7 >= 16'd8191 && Y >= 16 && Y <= 18), (vol7 >= 16'd16383 && Y >= 12 && Y <= 14), (vol7 >= 16'd32767 && Y >= 8 && Y <= 10), (vol7 >= 16'd65535 && Y >= 4 && Y <= 6)};                  

    always@(posedge clk24) begin
        if (display_flag == 3'd0) begin
            hold_C <= (btnC) ? (hold_C == 5'd23) ? 5'd23 : hold_C + 1 : 0;
            if (hold_C == 5'd23) exit_AUDVIS = 1;
            if (toggle_mode) begin
                vol7 <= vol6;
                vol6 <= vol5;
                vol5 <= vol4;
                vol4 <= vol3;
                vol3 <= vol2;
                vol2 <= vol1;
                vol1 <= vol0;
                vol0 <= volume24;
            end
            else begin     
                hold_L <= (btnL) ? (hold_L == 5'd23) ? 5'd23 : hold_L + 1 : 0;
                hold_R <= (btnR) ? (hold_R == 5'd23) ? 5'd23 : hold_R + 1 : 0;
                hold_U <= (btnU) ? (hold_U == 5'd23) ? 5'd23 : hold_U + 1 : 0;
                hold_D <= (btnD) ? (hold_D == 5'd23) ? 5'd23 : hold_D + 1 : 0;
                if (border_width >= bar_pos - bar_width && 95 - border_width - 1 <= bar_pos + bar_width + 1) bar_width = bar_width - 1;
                else if (bar_pos + bar_width + 2 <= 95 - border_width && (pulse_R || hold_R == 5'd23)) bar_pos = bar_pos + 1;
                else if (bar_pos - bar_width - 2 >= border_width && (pulse_L || hold_L == 5'd23)) bar_pos = bar_pos - 1;
                else if (border_width >=  bar_pos - bar_width) bar_pos = border_width + 1 + bar_width;
                else if (95 - border_width <= bar_pos + bar_width) bar_pos = 95 - border_width - bar_width - 1;
                else if (bar_width < 7'd46 - border_width && (pulse_U || hold_U == 5'd23)) bar_width = bar_width + 1;
                else if (bar_width > 7'd5 && (pulse_D || hold_D == 5'd23)) bar_width = bar_width - 1;
                else if (bar_width >= 7'd47 - border_width) bar_width = 7'd46 - border_width;
                else if (pulse_C) begin 
                    bar_pos = 7'd47;
                    bar_width = 7'd6;
                end
                else bar_pos = bar_pos; 
            end
        end
        else begin
            hold_L = 5'd0;
            hold_R = 5'd0;
            hold_U = 5'd0;
            hold_D = 5'd0;
            hold_C = 5'd0;
            bar_pos = 7'd47;
            bar_width = 7'd6;
            exit_AUDVIS = 0;
        end
    end
    
    always@(*) begin
        if (toggle_mode && show_bar) begin
            if ((pos[0] && bar0[4:0]) || (pos[1] && bar1[4:0]) || (pos[2] && bar2[4:0]) || (pos[3] && bar3[4:0]) || (pos[4] && bar4[4:0]) || (pos[5] && bar5[4:0]) || 
            (pos[6] && bar6[4:0]) || (pos[7] && bar7[4:0])) bar_data = hi_col;
            else if ((pos[0] && bar0[9:5]) || (pos[1] && bar1[9:5]) || (pos[2] && bar2[9:5]) || (pos[3] && bar3[9:5]) || (pos[4] && bar4[9:5]) || (pos[5] && bar5[9:5]) || 
            (pos[6] && bar6[9:5]) || (pos[7] && bar7[9:5])) bar_data = med_col;
            else if ((pos[0] && bar0[15:10]) || (pos[1] && bar1[15:10]) || (pos[2] && bar2[15:10]) || (pos[3] && bar3[15:10]) || (pos[4] && bar4[15:10]) || (pos[5] && bar5[15:10]) || 
            (pos[6] && bar6[15:10]) || (pos[7] && bar7[15:10])) bar_data = low_col;
            else bar_data = bg_col;
        end
        else if (bar && bar_range && show_bar) begin
            if (bar[5:0]) bar_data = low_col;
            if (bar[10:6]) bar_data = med_col;
            if (bar[15:11]) bar_data = hi_col;
        end
        else bar_data = bg_col;
    end
    
endmodule
