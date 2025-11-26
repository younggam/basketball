`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/26 14:54:35
// Design Name: 
// Module Name: game
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


module game (
    input wire clk,              // 게임 업데이트용 클럭 (예: 60Hz)
    input wire resetn,
    input wire [3:0] sw_speed_x, // 초기 수평 속도 [cite: 26]
    input wire [3:0] sw_speed_y, // 초기 수직 속도 [cite: 26]
    input wire btn_throw,
    output reg [9:0] ball_x,
    output reg [9:0] ball_y
);

    // 상태 정의
    localparam IDLE = 2'b00;   // 공 던지기 전
    localparam FLYING = 2'b01; // 공이 날아가는 중 
    localparam GOAL = 2'b10;   // 골인/종료
    
    localparam GOAL_X_LEFT=20;
    localparam GOAL_X_RIGHT=100;
    localparam GOAL_Y=100;
    localparam BALL_SIZE=20;
    localparam BALL_START_X=760;
    localparam BALL_START_Y=380;

    reg [1:0] state, next_state;
    
    // 물리 변수 (속도, 중력 등)
    reg signed [9:0] velocity_x, velocity_y;
    parameter GRAVITY = 1; // 중력 가속도 상수

    // 1. 상태 전이 로직 (Sequential)
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= IDLE;
            // 초기 위치 리셋
        end else begin
            state <= next_state;
            // 상태에 따른 좌표 업데이트 로직
            case (state)
                IDLE: begin
                    ball_x <= BALL_START_X;
                    ball_y <= BALL_START_Y;
                end
                FLYING: begin
                    ball_x <= ball_x + velocity_x;
                    ball_y <= ball_y + velocity_y; // 화면 좌표계는 아래가 +Y일 수 있음 유의
                    velocity_y <= velocity_y + GRAVITY; // 중력 적용 (포물선 운동)
                end
            endcase
            // ... (초기화 및 기타 로직)
        end
    end

    // 2. 다음 상태 결정 로직 (Combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (btn_throw) next_state = FLYING;
                else next_state = IDLE;
            end
            FLYING: begin
                // 바닥에 닿거나 골대에 닿으면 상태 변경
                if (ball_y >= 460) next_state = IDLE; // 바닥 닿음
                else if (ball_y==GOAL_Y) begin
                    if (ball_x > GOAL_X_LEFT && ball_x < GOAL_X_RIGHT) next_state = GOAL;
                    else begin
                        if (ball_x == GOAL_X_LEFT || ball_x == GOAL_X_RIGHT) begin
                            
                        end 
                        next_state = FLYING;
                    end
                end
                else next_state = FLYING;
            end
            // ...
        endcase
    end

endmodule