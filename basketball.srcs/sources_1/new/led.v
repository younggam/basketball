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
    
    always @(posedge tick_50ms or negedge resetn) begin
        if(!resetn) begin
            temp <= 0;
            i <= 0;
        end
        else begin
            temp <= score;
            i <= 0;
        end
    end
    
    always @(posedge tick_1ms or negedge resetn) begin
        if(!resetn) seg_data<=8'b0000_0000;
        else begin
            digit <= 1 << i;
            seg_data <= data_led(temp % 10);
            temp <= temp / 10;
            if(i == 7) i <= 0;
            else i <= i + 1;
        end
    end
endmodule
