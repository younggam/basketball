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
    parameter GRAVITY = 1, // 중력 가속도 상수
    
    parameter GOAL_X_LEFT=20,
    parameter GOAL_X_RIGHT=100,
    parameter GOAL_Y=100,
    parameter BALL_RADIUS=12,
    parameter PLAYER_X=600,
    parameter PLAYER_Y=360
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
    wire [9:0] pixel_x, pixel_y;
    wire video_on;
    wire [3:0] red, green, blue;
    
    tick #(
        .CNT_1MS(CNT_1MS)
    )tick_(
        .clk(clk),
        .resetn(resetn),
        .tick_1ms(tick_1ms),
        .tick_50ms(tick_50ms)        
    );
    
    game #(
        .GRAVITY(GRAVITY),
        .GOAL_X_LEFT(GOAL_X_LEFT),
        .GOAL_X_RIGHT(GOAL_X_RIGHT),
        .GOAL_Y(GOAL_Y),
        .BALL_RADIUS(BALL_RADIUS),
        .PLAYER_X(PLAYER_X),
        .PLAYER_Y(PLAYER_Y)
    )game_(
        .tick_50ms(tick_50ms),              
        .resetn(resetn),
        .sw_speed_x(sw_speed_x),
        .sw_speed_y(sw_speed_y),
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
    drawer #(
        .GOAL_X_LEFT(GOAL_X_LEFT), // 공의 반지름과 오브젝트 위치 상수
        .GOAL_X_RIGHT(GOAL_X_RIGHT),
        .GOAL_Y(GOAL_Y),
        .BALL_RADIUS(BALL_RADIUS),
        .PLAYER_X(PLAYER_X),
        .PLAYER_Y(PLAYER_Y)
    )drawer_(
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .red(red),
        .green(green),
        .blue(blue)
    );
endmodule
