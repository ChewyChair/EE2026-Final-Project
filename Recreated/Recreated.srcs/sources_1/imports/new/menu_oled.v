`timescale 1ns / 1ps

module menu_oled(input [1:0] toggle_color, input clk3, input [1:0] hover_flag, input [7:0] X, input [7:0] Y, output [15:0] oled_MENU);
            
    //wire ARROW1, ARROW2, ARROW3, ARROW4;
    wire [3:0] ARROW;
    reg [1:0] offset = 2'd0;
        
    assign ARROW[0] = (hover_flag == 2'd0) ? (X == 12 - offset && (Y >= 6 && Y <= 14)) || (X == 13 - offset && (Y >= 7 && Y <= 13)) || (X == 14 - offset && (Y >= 8 && Y <= 12)) || 
    (X == 15 - offset && (Y >= 9 && Y <= 11)) || (X == 16 - offset && (Y == 10)) ||
    (X == 82 + offset && (Y >= 6 && Y <= 14)) || (X == 81 + offset && (Y >= 7 && Y <= 13)) || (X == 80 + offset && (Y >= 8 && Y <= 12)) || 
    (X == 79 + offset && (Y >= 9 && Y <= 11)) || (X == 78 + offset && (Y == 10)) : 0;
    
    assign ARROW[1] = (hover_flag == 2'd1) ? (X == 12 - offset && (Y >= 21 && Y <= 29)) || (X == 13 - offset && (Y >= 22 && Y <= 28)) || (X == 14 - offset && (Y >= 23 && Y <= 27)) || 
    (X == 15 - offset && (Y >= 24 && Y <= 26)) || (X == 16 - offset && (Y == 25)) ||
    (X == 82 + offset && (Y >= 21 && Y <= 29)) || (X == 81 + offset && (Y >= 22 && Y <= 28)) || (X == 80 + offset && (Y >= 23 && Y <= 27)) || 
    (X == 79 + offset && (Y >= 24 && Y <= 26)) || (X == 78 + offset && (Y == 25)) : 0;
    
    assign ARROW[2] = (hover_flag == 2'd2) ? (X == 12 - offset && (Y >= 36 && Y <= 44)) || (X == 13 - offset && (Y >= 37 && Y <= 43)) || (X == 14 - offset && (Y >= 38 && Y <= 42)) || 
    (X == 15 - offset && (Y >= 39 && Y <= 41)) || (X == 16 - offset && (Y == 40)) ||
    (X == 82 + offset && (Y >= 36 && Y<= 44)) || (X == 81 + offset && (Y >= 37 && Y <= 43)) || (X == 80 + offset && (Y >= 38 && Y <= 42)) || 
    (X == 79 + offset && (Y >= 39 && Y <= 41)) || (X == 78 + offset && (Y == 40)) : 0;
    
    assign ARROW[3] = (hover_flag == 2'd3) ? (X == 12 - offset && (Y >= 51 && Y <= 59)) || (X == 13 - offset && (Y >= 52 && Y <= 58)) || (X == 14 - offset && (Y >= 53 && Y <= 57)) || 
    (X == 15 - offset && (Y >= 54 && Y <= 56)) || (X == 16 - offset && (Y == 55)) ||
    (X == 82 + offset && (Y >= 51 && Y <= 59)) || (X == 81 + offset && (Y >= 52 && Y <= 58)) || (X == 80 + offset && (Y >= 53 && Y <= 57)) || 
    (X == 79 + offset && (Y >= 54 && Y <= 56)) || (X == 78 + offset && (Y == 55)) : 0;
    
    wire [3:0] BORD;
    wire [3:0] bord_offset;
    assign bord_offset[0] = hover_flag == 2'd0;
    assign bord_offset[1] = hover_flag == 2'd1;  
    assign bord_offset[2] = hover_flag == 2'd2; 
    assign bord_offset[3] = hover_flag == 2'd3; 
    
    assign BORD[0] = (X == 19 - bord_offset[0] && (Y >= 4 - bord_offset[0] && Y <= 16 + bord_offset[0])) || (X == 75 + bord_offset[0] && 
    (Y >= 4 - bord_offset[0] && Y <= 16 + bord_offset[0])) || ((X >= 19 - bord_offset[0] && X <= 75 + bord_offset[0]) && (Y == 4 - bord_offset[0] || Y == 16 + bord_offset[0]));
    assign BORD[1] = (X == 19 - bord_offset[1] && (Y >= 19 - bord_offset[1] && Y <= 31 + bord_offset[1])) || (X == 75 + bord_offset[1] && 
    (Y >= 19 - bord_offset[1] && Y <= 31 + bord_offset[1])) || ((X >= 19 - bord_offset[1] && X <= 75 + bord_offset[1]) && (Y == 19 - bord_offset[1] || Y == 31 + bord_offset[1]));
    assign BORD[2] = (X == 19 - bord_offset[2] && (Y >= 34 - bord_offset[2] && Y <= 46 + bord_offset[2])) || (X == 75 + bord_offset[2] && 
    (Y >= 34 - bord_offset[2] && Y <= 46 + bord_offset[2])) || ((X >= 19 - bord_offset[2] && X <= 75 + bord_offset[2]) && (Y == 34 - bord_offset[2] || Y == 46 + bord_offset[2]));
    assign BORD[3] = (X == 19 - bord_offset[3] && (Y >= 49 - bord_offset[3] && Y <= 61 + bord_offset[3])) || (X == 75 + bord_offset[3] && 
    (Y >= 49 - bord_offset[3] && Y <= 61 + bord_offset[3])) || ((X >= 19 - bord_offset[3] && X <= 75 + bord_offset[3]) && (Y == 49 - bord_offset[3] || Y == 61 + bord_offset[3]));
    
    wire TEXT_AUDVIS;
    
    assign TEXT_AUDVIS = (Y == 6 && (X >= 24 && X <= 25)) || (Y == 7 && (X == 23 || X == 26)) || ((X == 22 || X == 27) && (Y >= 8 && Y <= 12)) || 
    (Y == 10 && (X >= 22 && X <= 27)) || (Y == 13 && ((X >= 21 && X <= 23) || (X >= 26 && X <= 28))) ||//A Y6-Y13, X21-X28
    (Y == 6 && ((X >= 30 && X <= 32) || (X >= 35 && X <= 37))) || (Y == 13 && (X >= 32 && X <= 35)) || ((Y >= 6 && Y <= 13) && (X == 31 || X == 36)) || //U X30-X37
    ((Y == 6 || Y == 13) && (X >= 39 && X <= 44)) || ((Y >= 7 && Y <= 12) && X == 40) || (X == 45 && (Y == 7 || Y == 12)) || (X == 46 && (Y >= 8 && Y <= 11)) || //D X39-X46
    (Y == 6 && ((X >= 48 && X <= 50) || (X >= 53 && X <= 55))) || (X == 49 && (Y >= 7 && Y <= 9)) || (X == 50 && (Y >= 10 && Y <= 11)) || (X == 51 && Y == 12) ||
    (X == 52 && Y == 13) || (X == 53 && (Y >= 11 && Y <= 12)) || (X == 54 && (Y >= 7 && Y <= 10)) ||//V X48-X55
    ((Y == 6 || Y == 13) && (X >= 57 && X <= 64)) || (X == 60 && (Y >= 6 && Y <= 13)) ||//I X57-X64
    (X == 66 && ((Y >= 7 && Y <= 8) || (Y >= 11 && Y <= 13))) || (X == 73 && ((Y >= 6 && Y <= 8) || (Y >= 11 && Y <= 12))) || ((Y == 6 || Y == 9) && (X >= 67 && X <= 71)) ||
    (Y == 13 && (X >= 68 && X <= 72)) || (Y == 12 && X == 67) || (X == 72 && (Y == 7 || Y == 10)) //S X66-X73  
    ;

    wire TEXT_SBR;
    
    assign TEXT_SBR = (X == 23 && (Y >= 21 && Y <= 27)) || (Y == 28 && (X >= 24 && X <= 28)) || (Y == 27 && X == 29) || //shi Y21-29, X23-29
    (X == 33 && (Y >= 21 && Y <= 28)) || (Y == 23 && (X >= 35 && X <= 39)) || (X == 38 && (Y >= 21 && Y <= 27)) || ((X == 36 || X == 37) && (Y == 28 || Y == 26)) ||
    (X == 35 && Y == 27) || (X == 39 && Y == 28) || ((X == 40 || X == 42) && Y == 21) || //ba X33-42
    ((X == 44 || X == 45) && (Y == 24 || Y == 25)) ||  //dot
    (Y == 21 && (X >= 48 && X <= 54)) || (Y == 25 && (X >= 49 && X <= 54)) || (Y == 28 && (X >= 48 && X <= 50)) || (X == 49 && (Y >= 21 && Y <= 28)) || 
    ((X >= 53 && X <= 55) && Y == 28) || (X == 55 && (Y >= 22 && Y <= 24)) || (X == 53 && Y == 26) || (X == 54 && Y == 27) || //R X48-55
    (Y == 21 && ((X >= 57 && X <= 59) || (X >= 62 && X <= 64))) || (Y == 28 && (X >= 59 && X <= 62)) || ((Y >= 21 && Y <= 28) && (X == 58 || X == 63)) || //U X57-X64
    ((X == 67 || X == 72) && (Y >= 21 && Y <= 28)) || ((X >= 70 && X <= 73) && (Y == 21 || Y == 28)) || ((X >= 66 && X <= 68) && Y == 28) || (X == 66 && Y == 21) ||
    (X == 68 && Y == 22) || (X == 69 && Y == 23) || (X == 70 && Y == 24) || (X == 71 && Y == 25) //N X66-73
    ;
    
    wire TEXT_PONG;
    
    assign TEXT_PONG = ((X == 32) && (Y >= 36 && Y <= 43)) || ((X >= 33 && X <= 36) && (Y == 36 || Y == 40)) || ((X == 37) && (Y >= 37 && Y <= 39)) || //P
    ((X == 39 || X == 44) && (Y >= 36 && Y <= 43)) || ((Y == 36 || Y == 43) && (X >= 40 && X <= 43)) || // O
    ((X == 47 || X == 52) && (Y >= 36 && Y <= 43)) || ((X >= 50 && X <= 53) && (Y == 36 || Y == 43)) || ((X >= 46 && X <= 48) && Y == 43) || (X == 46 && Y == 36) ||
    (X == 48 && Y == 37) || (X == 49 && Y == 38) || (X == 50 && Y == 39) || (X == 51 && Y == 40) || // N
    ((X == 55) && (Y >= 37 && Y <= 42)) || ((X >= 56 && X <= 59) && (Y == 36 || Y == 43)) || (X == 60 && (Y == 37 || (Y >= 40 && Y <= 42))) || 
    (Y == 40 && (X >= 58 && X <= 60)) || // G
    (X == 62 && ((Y == 43) || (Y >= 36 && Y <= 41))); 
    
    wire TEXT_TOWERDEF;
    assign TEXT_TOWERDEF = ((X >= 22 && X <= 28) && (Y == 51)) || (X == 25 && (Y >= 52 && Y <= 58)) || // T
    ((X == 30 || X == 35) && (Y >= 51 && Y <= 58)) || ((Y == 51 || Y == 58) && (X >= 31 && X <= 34)) || // O
    ((X == 37 || X == 43) && (Y >= 51 && Y <= 58)) || (X == 40 && (Y >= 53 && Y <= 55)) || (Y == 56 && (X == 39 || X == 41)) || (Y == 57 && (X == 38 || X == 42)) ||// W
    (X == 45 && (Y >= 51 && Y <= 58)) || ((X >= 46 && X <= 48) && (Y == 51 || Y == 54 || Y == 58)) || // E
    (X == 50 && (Y >= 51 && Y <= 58)) || ((X >= 51 && X <= 53) && (Y == 51 || Y == 55)) || ((X >= 54 && X <= 55) && (Y == 52 || Y == 54)) || (X == 55 && Y == 53) ||
    (X == 54 && Y == 56) || (X == 55 && (Y >= 57 && Y <= 58)) || // R
    ((Y == 51 || Y == 58) && (X >= 58 && X <= 61)) || (X == 59 && (Y >= 52 && Y <= 57)) || ((X >= 62 && X <= 63) && (Y == 52 || Y == 57)) || (X == 63 && (Y >= 53 && Y <= 56)) || // D
    (X == 65 && (Y >= 51 && Y <= 58)) || ((X >= 66 && X <= 68) && (Y == 51 || Y == 54 || Y == 58)) || // E
    (X == 70 && (Y >= 51 && Y <= 58)) || ((X >= 71 && X <= 73) && (Y == 51 || Y == 54))// E
    ;
    
    always@(posedge clk3) begin
        offset = (offset == 2'd0) ? 2'd3 : 2'd0;
    end
    
    wire [15:0] bg_col;
    assign bg_col = (toggle_color == 2'b11) ? 16'h3049 :
                    (toggle_color == 2'b10) ? 16'h0161 :
                    (toggle_color == 2'b01) ? 16'h0927 :
                    16'h0000;
                    
    wire [15:0] menu_col;                   
    assign menu_col = (toggle_color == 2'b11) ? 16'hC01F : 
                      (toggle_color == 2'b10) ? 16'h07E9 : 
                      (toggle_color == 2'b01) ? 16'h06DF : 
                      16'hFFFF;
                      
    wire [15:0] select_col;
    assign select_col = 16'hFFC3;
    
    assign oled_MENU = (hover_flag == 2'd0) ? (ARROW[3:0] || BORD[0] || TEXT_AUDVIS) ? select_col : (BORD[3:1] || TEXT_SBR || TEXT_PONG || TEXT_TOWERDEF) ? menu_col : bg_col :
                       (hover_flag == 2'd1) ? (ARROW[3:0] || BORD[1] || TEXT_SBR) ? select_col : (BORD[3:2] || BORD[0] || TEXT_AUDVIS || TEXT_PONG || TEXT_TOWERDEF) ? menu_col : bg_col :
                       (hover_flag == 2'd2) ? (ARROW[3:0] || BORD[2] || TEXT_PONG) ? select_col : (BORD[3] || BORD[1:0] || TEXT_AUDVIS || TEXT_SBR || TEXT_TOWERDEF) ? menu_col : bg_col : 
                       (hover_flag == 2'd3) ? (ARROW[3:0] || BORD[3] || TEXT_TOWERDEF) ? select_col : (BORD[2:0] || TEXT_AUDVIS || TEXT_SBR || TEXT_PONG) ? menu_col : bg_col : 
                       16'h0;
    
endmodule
