`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/27 22:41:28
// Design Name: 
// Module Name: drawer
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


module drawer#(
    parameter GOAL_X_LEFT=20, // 공의 반지름과 오브젝트 위치 상수
    parameter GOAL_X_RIGHT=100,
    parameter GOAL_Y=100,
    parameter BALL_RADIUS=12,
    parameter PLAYER_X=760,
    parameter PLAYER_Y=380
)
(
    input wire [9:0] pixel_x, pixel_y,
    input wire video_on,
    input wire [9:0] ball_x, ball_y,
    output reg [3:0] red, green, blue
);
    always @(*) begin
        if (!video_on) begin
            {red, green, blue} = 12'h000;
        end else begin
            // 1. 공 그리기 (원형 방정식 또는 사각형 단순화) [cite: 19]
            if ((pixel_x - ball_x)*(pixel_x - ball_x) + (pixel_y - ball_y)*(pixel_y - ball_y) <= BALL_RADIUS*BALL_RADIUS) begin
                {red, green, blue} = 12'hF80; // 주황색
            end
            // 2. 플레이어 그리기 (녹색 사각형) 
            else if (pixel_x > PLAYER_X && pixel_x <= PLAYER_X+40 && pixel_y > PLAYER_Y && pixel_y <= PLAYER_Y+120) begin
                {red, green, blue} = 12'h0F0; // 녹색
            end
            // 3. 골대 림 그리기 (빨간색) [cite: 24]
            else if (pixel_x >= GOAL_X_LEFT && pixel_x <= GOAL_X_RIGHT && pixel_y >= GOAL_Y && pixel_y < GOAL_Y+10) begin
                {red, green, blue} = 12'hF00; // 빨간색
            end
            // 4. 골대 그물 그리기 (회색)
            else if (pixel_x + pixel_x >= GOAL_X_LEFT + GOAL_X_LEFT + pixel_y - (GOAL_Y + 10) 
            && pixel_x + pixel_x <= GOAL_X_RIGHT + GOAL_X_RIGHT + GOAL_Y + 10 - pixel_y && pixel_y >= GOAL_Y + 10 && pixel_y < GOAL_Y+30) begin
                {red, green, blue} = 12'hCCC; // 회색
            end
            else if (pixel_x >= GOAL_X_LEFT + 10 && pixel_x <= GOAL_X_RIGHT - 10 && pixel_y >= GOAL_Y + 30 && pixel_y < GOAL_Y+60) begin
                {red, green, blue} = 12'hCCC; // 회색
            end
            // 5. 배경 (검은색)
            else begin
                {red, green, blue} = 12'h000;
            end
        end
    end
endmodule