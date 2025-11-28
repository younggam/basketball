`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/21 15:28:40
// Design Name: 
// Module Name: data_led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


function [7:0] data_led;
    input [3:0] addr_in;
    begin
        case (addr_in)
            0: data_led=8'b0011_1111;
            1: data_led=8'b0000_0110;
            2: data_led=8'b0101_1011;
            3: data_led=8'b0010_1111;
            4: data_led=8'b0110_0110;
            5: data_led=8'b0110_1101;
            6: data_led=8'b0111_1101;
            7: data_led=8'b0010_0111;
            8: data_led=8'b0111_1111;
            9: data_led=8'b0110_1111;
            default: data_led=8'b0000_0000;
        endcase
    end
endfunction
