`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): TUESDAY A.M
//
//  STUDENT A NAME: MARCUS ONG YIH
//  STUDENT A MATRICULATION NUMBER: A0217368X
//
//  STUDENT B NAME: CHEW YI JIE
//  STUDENT B MATRICULATION NUMBER: A0217596R
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v  
    output [7:0] JC,
    input btnC,
    input btnL,
    input btnR,
    input btnU,
    input btnD,
    input clock,
    input [8:0] sw,  
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an
    ); 
   
    wire clk6p25m;
    wire clk24;
    wire clk10;
    wire clk20k;
    wire clk3;
    wire clk381;
    wire reset;
    wire [15:0] oled_data;
    wire [11:0] mic_in; 
    wire frame_begin;
    wire sending_pixels;
    wire sample_pixel;
    wire [12:0] pixel_index;
    wire teststate;
    wire [15:0] volume10;
    wire [15:0] volume24;
    wire [6:0] X, Y;
    
    wire pulse_L;
    wire pulse_R;

    assign led = (sw[0]) ? volume10 : mic_in;

    slowclock clk20khz(clock, clk20k, 16'd2499);
    slowclock clk6p25mhz(clock, clk6p25m, 3'd7);
    slowclock clk24hz(clock, clk24, 21'd2083332); 
    slowclock clk10hz(clock, clk10, 23'd4999999);
    slowclock clk3hz(clock, clk3, 24'd16666666);
    slowclock clk381hz(clock, clk381, 18'd131233);
    //debounced_button DB_C(clk24, btnC, reset); no longer in use
    max_vol(clk20k, clk10, clk24, mic_in, volume10, volume24);
    
    getcoords COORDS(pixel_index, X, Y);
    Audio_Capture AC(clock, clk20k, J_MIC3_Pin3, J_MIC3_Pin1, J_MIC3_Pin4, mic_in); 
    Oled_Display OLED(clk6p25m, reset, frame_begin, sending_pixels, sample_pixel, pixel_index, oled_data, JC[0], JC[1], JC[3], JC[4], JC[5], JC[6], JC[7], teststate);
    
    wire [2:0] display_flag;
    wire [2:0] select_flag;
    wire [15:0] oled_MENU;
    wire [15:0] oled_AUDVIS;
    wire exit_AUDVIS;
    wire [15:0] oled_SBR;
    wire [9:0] score_sbr;
    wire exit_SBR;
    wire [15:0] oled_shooter;
    wire exit_shooter;
    wire [15:0] oled_PONG;
    wire exit_pong;
    wire [15:0] oled_towerdef;
    wire exit_towerdef;
    wire secret;
    wire [5:0] score_td;
    wire [1:0] forcefield_td;
    

    Oled_DRIVER_main OLEDMAINDRIVER(clk24, select_flag, oled_data, oled_MENU, oled_AUDVIS, oled_SBR, oled_shooter, oled_PONG, oled_towerdef, exit_AUDVIS, exit_SBR, exit_shooter, exit_pong, exit_towerdef, display_flag, secret);
    
    segment_driver SEGDRIV(clk10, clk381, seg, an, volume10, sw[1], score_sbr, display_flag, secret, score_td, forcefield_td);
    
    Oled_DRIVER_menu MENU(sw[5:4], clk3, clk24, select_flag, btnU, btnD, btnC, btnL, btnR, X, Y, oled_MENU, display_flag, exit_shooter, secret);
    
    Oled_DRIVER_visualiser AUDVIS(sw[3:2], sw[5:4], sw[6], btnL, btnR, btnC, btnU, btnD, clk24, volume10, volume24, X, Y, oled_AUDVIS, exit_AUDVIS, display_flag, sw[7]);
    
    Oled_DRIVER_shibarun SBR(clk6p25m, clk24, sw[7], sw[8], sw[6], volume24, btnU, btnL, btnR, btnC, X, Y, pixel_index, oled_SBR, exit_SBR, display_flag, score_sbr);
    
    Oled_DRIVER_shooter(clk6p25m, clk24, sw[1], sw[2], sw[7], sw[8], sw[6], volume24, btnU, btnD, btnL, btnR, btnC, X, Y, pixel_index, oled_shooter, exit_shooter, secret);

    Oled_DRIVER_pong PONG(clk6p25m, clk24, sw[6], volume24, btnL, btnR, btnC, X, Y, pixel_index, oled_PONG, exit_pong, display_flag);
    
    Oled_DRIVER_towerdef TD(clk6p25m, clk24, volume24, sw[6], btnD, btnU, btnC, btnL, X, Y, pixel_index, oled_towerdef, exit_towerdef, display_flag, score_td, forcefield_td);  
    
endmodule