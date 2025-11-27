`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/26 14:47:27
// Design Name: 
// Module Name: basketball
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


module basketball#(
    parameter CNT_1MS=100000,
    parameter GRAVITY = 1 // 중력 가속도 상수
)(
    input wire clk,
    input wire resetn,
    input wire [3:0] sw_speed_x, // 초기 수평 속도 [cite: 26]
    input wire [3:0] sw_speed_y, // 초기 수직 속도 [cite: 26]
    input wire btn_throw,
    output reg [7:0] digit,
    output reg [7:0] seg_data
);
    wire tick_1ms, tick_50ms;
    wire [15:0] score;
    wire [9:0] ball_x, ball_y;
    
    tick tick_(
        .clk(clk),
        .resetn(resetn),
        .tick_1ms(tick_1ms),
        .tick_50ms(tick_50ms)        
    );
    
    game game_(
        .tick_50ms(tick_50ms),              
        .resetn(resetn),
        .sw_speed_x(sw_speed_x), // 초기 수평 속도 [cite: 26]
        .sw_speed_y(sw_speed_y), // 초기 수직 속도 [cite: 26]
        .btn_throw(btn_throw),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .score(score)
    );
    led led_(
        .tick_1ms(tick_1ms),
        .tick_50ms(tick_50ms),
        .resetn(resetn),
        .score(score),
        .digit(digit),
        .seg_data(seg_data)
    );
endmodule
