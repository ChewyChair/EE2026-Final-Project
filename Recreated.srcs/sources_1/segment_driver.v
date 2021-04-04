`timescale 1ns / 1ps

module segment_driver(input clk10, input clk381, output reg [6:0] seg, output reg [3:0] an, input [15:0] volume, input sw, input [9:0] score_sbr, input [2:0] display_flag,
input secret, input [5:0] score_td, input [1:0] forcefield_td);

    reg [1:0] sequence = 0;
    reg [6:0] ones = 7'b1111111;
    reg [6:0] tens = 7'b1111111;
    reg [6:0] hundreds = 7'b1111111;
    reg [6:0] thousands = 7'b1111111;
    reg [6:0] level = 7'b1111111;
    reg [6:0] forcefields = 7'b1111111;
    
    always@(posedge clk10) begin
        if (display_flag == 3'd0) begin
            case(volume)
                16'd0: begin
                    ones <= 7'b1000000;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1000111 : 7'b1111111;
                end
                16'd1: begin
                    ones <= 7'b1000000;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1000111 : 7'b1111111;
                end
                16'd3: begin
                    ones <= 7'b1111001;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1000111 : 7'b1111111;
                end
                16'd7: begin
                    ones <= 7'b0100100;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1000111 : 7'b1111111;
                end
                16'd15: begin
                    ones <= 7'b0110000;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1000111 : 7'b1111111;
                end
                16'd31: begin
                    ones <= 7'b0011001;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1000111 : 7'b1111111;
                end
                16'd63: begin
                    ones <= 7'b0010010;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1000111 : 7'b1111111;
                end
                16'd127: begin
                    ones <= 7'b0000010;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1101010 : 7'b1111111;
                end
                16'd255: begin
                    ones <= 7'b1111000;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1101010 : 7'b1111111;
                end
                16'd511: begin
                    ones <= 7'b0000000;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1101010 : 7'b1111111;
                end
                16'd1023: begin
                    ones <= 7'b0010000;
                    tens <= 7'b1111111;
                    level <= (sw) ? 7'b1101010 : 7'b1111111;
                end
                16'd2047: begin
                    ones <= 7'b1000000;
                    tens <= 7'b1111001;
                    level <= (sw) ? 7'b1101010 : 7'b1111111;
                end
                16'd4095: begin
                    ones <= 7'b1111001;
                    tens <= 7'b1111001;
                    level <= (sw) ? 7'b0001001 : 7'b1111111;
                end
                16'd8191: begin
                    ones <= 7'b0100100;
                    tens <= 7'b1111001;
                    level <= (sw) ? 7'b0001001 : 7'b1111111;
                end
                16'd16383: begin
                    ones <= 7'b0110000;
                    tens <= 7'b1111001;
                    level <= (sw) ? 7'b0001001 : 7'b1111111;
                end
                16'd32767: begin
                    ones <= 7'b0011001;
                    tens <= 7'b1111001;
                    level <= (sw) ? 7'b0001001 : 7'b1111111;
                end
                16'd65535: begin
                    ones <= 7'b0010010;
                    tens <= 7'b1111001;
                    level <= (sw) ? 7'b0001001 : 7'b1111111;
                end
            endcase
        end 
        if (display_flag == 3'd1) begin
            ones <= 7'b1000000;
            case(score_sbr % 10)
                10'd0: tens <= 7'b1000000;
                10'd1: tens <= 7'b1111001;
                10'd2: tens <= 7'b0100100;
                10'd3: tens <= 7'b0110000;
                10'd4: tens <= 7'b0011001;
                10'd5: tens <= 7'b0010010;
                10'd6: tens <= 7'b0000010;
                10'd7: tens <= 7'b1111000;
                10'd8: tens <= 7'b0000000;
                10'd9: tens <= 7'b0010000;
            endcase
            case((score_sbr / 10) % 10)
                10'd0: hundreds <= 7'b1000000;
                10'd1: hundreds <= 7'b1111001;
                10'd2: hundreds <= 7'b0100100;
                10'd3: hundreds <= 7'b0110000;
                10'd4: hundreds <= 7'b0011001;
                10'd5: hundreds <= 7'b0010010;
                10'd6: hundreds <= 7'b0000010;
                10'd7: hundreds <= 7'b1111000;
                10'd8: hundreds <= 7'b0000000;
                10'd9: hundreds <= 7'b0010000;
            endcase
            case((score_sbr / 100) % 10)
                10'd0: thousands <= 7'b1000000;
                10'd1: thousands <= 7'b1111001;
                10'd2: thousands <= 7'b0100100;
                10'd3: thousands <= 7'b0110000;
                10'd4: thousands <= 7'b0011001;
                10'd5: thousands <= 7'b0010010;
                10'd6: thousands <= 7'b0000010;
                10'd7: thousands <= 7'b1111000;
                10'd8: thousands <= 7'b0000000;
                10'd9: thousands <= 7'b0010000;
            endcase
        end 
        if (display_flag == 3'd3) begin
            case (forcefield_td)
                10'd0: forcefields <= 7'b1000000;
                10'd1: forcefields <= 7'b1111001;
                10'd2: forcefields <= 7'b0100100;
                10'd3: forcefields <= 7'b0110000;
            endcase
            case (score_td % 10)
                10'd0: ones <= 7'b1000000;
                10'd1: ones <= 7'b1111001;
                10'd2: ones <= 7'b0100100;
                10'd3: ones <= 7'b0110000;
                10'd4: ones <= 7'b0011001;
                10'd5: ones <= 7'b0010010;
                10'd6: ones <= 7'b0000010;
                10'd7: ones <= 7'b1111000;
                10'd8: ones <= 7'b0000000;
                10'd9: ones <= 7'b0010000;
            endcase
            case ((score_td / 10) % 10)
                10'd0: tens <= 7'b1000000;
                10'd1: tens <= 7'b1111001;
                10'd2: tens <= 7'b0100100;
                10'd3: tens <= 7'b0110000;
                10'd4: tens <= 7'b0011001;
                10'd5: tens <= 7'b0010010;
                10'd6: tens <= 7'b0000010;
                10'd7: tens <= 7'b1111000;
                10'd8: tens <= 7'b0000000;
                10'd9: tens <= 7'b0010000;
            endcase
        end
    end
                
    reg [6:0] M = 7'b1101010, E = 7'b0000110, N = 7'b0101011, U = 7'b1000001;
    reg [6:0] S = 7'b0010010, C = 7'b1000110, R = 7'b0101111, T = 7'b0000111;
    reg [6:0] P = 7'b0001100, O = 7'b1000000, G = 7'b0010000;
    
    always@(posedge clk381) begin
        sequence <= sequence + 1;
        if (display_flag == 3'd0) begin
            case(sequence)
                2'd0: begin
                    an <= 4'b0111;
                    seg <= level;
                end
                2'd1: begin
                    an <= 4'b1011;
                    seg <= 7'b1111111;
                end
                2'd2: begin
                    an <= 4'b1101;
                    seg <= tens;
                end
                2'd3: begin
                    an <= 4'b1110;
                    seg <= ones;
                end
            endcase
        end
        else if (display_flag == 3'd1) begin
            case(sequence) 
                2'd0: begin
                    an <= 4'b0111;
                    seg <= thousands;
                end
                2'd1: begin
                    an <= 4'b1011;
                    seg <= hundreds;
                end
                2'd2: begin
                    an <= 4'b1101;
                    seg <= tens;
                end
                2'd3: begin
                    an <= 4'b1110;
                    seg <= ones;
                end
            endcase
        end     
        else if (display_flag == 3'd2) begin
            case(sequence)
                2'd0: begin
                    an <= 4'b0111;
                    seg <= P;
                end
                2'd1: begin
                    an <= 4'b1011;
                    seg <= O;
                end
                2'd2: begin
                    an <= 4'b1101;
                    seg <= N;
                end
                2'd3: begin
                    an <= 4'b1110;
                    seg <= G;
                end
            endcase
        end
        else if (display_flag == 3'd3) begin
            case(sequence)
                2'd0:begin
                    an <= 4'b0111;
                    seg <= forcefields;
                end
                2'd1:begin
                    an <= 4'b1011;
                    seg <= 7'b0001110;
                end
                2'd2:begin
                    an <= 4'b1101;
                    seg <= tens;
                end
                2'd3:begin
                    an <= 4'b1110;
                    seg <= ones;
                end
            endcase
        end
        else if (secret) begin
            case(sequence)
                2'd0: begin
                    an <= 4'b0111;
                    seg <= S;
                end
                2'd1: begin
                    an <= 4'b1011;
                    seg <= C;
                end
                2'd2: begin
                    an <= 4'b1101;
                    seg <= R;
                end
                2'd3: begin
                    an <= 4'b1110;
                    seg <= T;
                end
            endcase
        end
        else begin
            case(sequence)
                2'd0: begin
                    an <= 4'b0111;
                    seg <= M;
                end
                2'd1: begin
                    an <= 4'b1011;
                    seg <= E;
                end
                2'd2: begin
                    an <= 4'b1101;
                    seg <= N;
                end
                2'd3: begin
                    an <= 4'b1110;
                    seg <= U;
                end
            endcase
        end
    end                                 
    
endmodule
