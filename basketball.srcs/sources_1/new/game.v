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
    localparam BALL_RADIUS=12;
    localparam BALL_START_X=760;
    localparam BALL_START_Y=380;

    reg [1:0] state, next_state;
    reg [15:0] score;
    
    // 물리 변수 (속도, 중력 등)
    reg signed [9:0] velocity_x, velocity_y;
    parameter GRAVITY = 1; // 중력 가속도 상수

    // 1. 상태 전이 로직 (Sequential)
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= IDLE;
            ball_x <= BALL_START_X;
            ball_y <= BALL_START_Y;
        end else begin
            state <= next_state;
            // 상태에 따른 좌표 업데이트 로직
            case (state)
                // 초기 위치 고정
                IDLE: begin
                    ball_x <= BALL_START_X;
                    ball_y <= BALL_START_Y;
                end
                FLYING, GOAL: begin
                    // 골대와 충돌 시 반발
                    if (ball_y - GOAL_Y <= BALL_RADIUS && GOAL_Y - ball_y <= BALL_RADIUS) begin // Y 검사
                        if (ball_x - GOAL_X_LEFT <= BALL_RADIUS && GOAL_X_LEFT - ball_x <= BALL_RADIUS) begin // 골대 왼쪽 끝과 충돌
                            if (ball_x - GOAL_X_LEFT >= ball_y - GOAL_Y  
                                || GOAL_X_LEFT - ball_x >= ball_y - GOAL_Y) velocity_x <= -velocity_x; // 좌 우 에서 접근 판별
                            else velocity_y <= -velocity_y; // 아래 위 에서 접근 판별
                        end
                        else if (ball_x - GOAL_X_RIGHT <= BALL_RADIUS && GOAL_X_RIGHT - ball_x <= BALL_RADIUS) begin // 골대 오른쪽 끝과 충돌
                            if (ball_x - GOAL_X_RIGHT >= ball_y - GOAL_Y
                                || GOAL_X_RIGHT - ball_x >= ball_y - GOAL_Y) velocity_x <= -velocity_x; // 좌 우 에서 접근 판별
                            else velocity_y <= -velocity_y; // 아래 위에서 접근 판별
                        end
                    end
                    ball_x <= ball_x + velocity_x;
                    ball_y <= ball_y + velocity_y;
                    velocity_y <= velocity_y + GRAVITY; // 중력 적용 (포물선 운동)
                end
            endcase
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
                else if (ball_y - GOAL_Y <= BALL_RADIUS && GOAL_Y - ball_y <= BALL_RADIUS
                    && ball_x - GOAL_X_LEFT > BALL_RADIUS && GOAL_X_RIGHT - ball_x > BALL_RADIUS
                    && velocity_y <= 0) begin
                    score = score + 1; // 골 점수
                    velocity_x = velocity_x >>> 1; // 골망 효과 속도 감소
                    velocity_y = velocity_y >>> 1;
                    next_state = GOAL;
                end
                else next_state = FLYING;
            end
            GOAL: begin
                if (ball_y >= 460) next_state = IDLE; // 바닥 닿음
                else next_state = GOAL;
            end
        endcase
    end

endmodule