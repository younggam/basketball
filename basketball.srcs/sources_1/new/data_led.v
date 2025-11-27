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
            0: data_led=8'b1111_1100;
            1: data_led=8'b0110_0000;
            2: data_led=8'b1101_1010;
            3: data_led=8'b1111_0010;
            4: data_led=8'b0110_0110;
            5: data_led=8'b1011_0110;
            6: data_led=8'b1011_1110;
            7: data_led=8'b1110_0100;
            8: data_led=8'b1111_1110;
            9: data_led=8'b1111_0110;
            default: data_led=8'b0000_0000;
        endcase
    end
endfunction
