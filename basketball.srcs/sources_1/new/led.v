`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/27 21:42:57
// Design Name: 
// Module Name: lcd
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


module led(
    input wire clk,
    input wire tick_1ms,
    input wire tick_50ms,
    input wire resetn,
    input wire [15:0] score,
    output reg [7:0] digit,
    output reg [7:0] seg_data
);
    reg [15:0] temp;
    reg [2:0] i;
    
    `include "data_led.v"
    
    always @(posedge clk or negedge resetn) begin
        if(!resetn) begin
            seg_data<=8'b0000_0000; 
            temp <= 0;
            i <= 7;
        end
        else begin
            if(tick_1ms) begin
                digit <= 1 << i;
                seg_data <= data_led(temp % 10);
                temp <= temp / 10;
                if(i == 0) begin
                    temp <= score;
                    i <= 7;
                end
                else i <= i - 1;
            end
            if (tick_50ms) begin
                temp <= score;
                i <= 7;
            end
        end
    end
endmodule
