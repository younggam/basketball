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


module game
#(
    parameter GRAVITY = 1, // 중력 가속도 상수
    parameter GOAL_X_LEFT=20,
    parameter GOAL_X_RIGHT=100,
    parameter GOAL_Y=100,
    parameter BALL_RADIUS=12,
    parameter PLAYER_X=760,
    parameter PLAYER_Y=380
)(
    input wire tick_50ms,              
    input wire resetn,
    input wire [3:0] sw_speed_x, // 초기 수평 속도 [cite: 26]
    input wire [3:0] sw_speed_y, // 초기 수직 속도 [cite: 26]
    input wire btn_throw,
    output reg [9:0] ball_x,
    output reg [9:0] ball_y,
    output reg [15:0] score
);

    `include "math.v"

    // 상태 정의
    localparam IDLE = 2'b00;   // 공 던지기 전
    localparam FLYING = 2'b01; // 공이 날아가는 중 
    localparam GOAL = 2'b10;   // 골인/종료

    reg [3:0] power;
    reg empowering;
    reg [1:0] state, next_state;
    
    // 물리 변수 (속도, 중력 등)
    reg signed [9:0] velocity_x, velocity_y;
    
    reg [1:0] cnt_200ms;
    reg tick_200ms;
    
    // power 조절용 기준
    always @(posedge tick_50ms or negedge resetn) begin
        if (!resetn) begin
            cnt_200ms <= 0;
            tick_200ms <= 0;
        end
        else begin
            if (power > 0) begin
                if (tick_50ms) begin
                    if (cnt_200ms == 3) begin
                        cnt_200ms <= 0;
                        tick_200ms <= 1;
                    end
                    else cnt_200ms <= cnt_200ms + 1;
                end
                else tick_200ms <= 0;
            end
            else begin
                cnt_200ms <= 0;
                tick_200ms <= 0;
            end
        end
    end

    // 1. 상태 전이 로직 (Sequential)
    always @(posedge tick_50ms or negedge resetn) begin
        if (!resetn) begin
            power <= 0;
            state <= IDLE;
            score <= 0;
            ball_x <= PLAYER_X;
            ball_y <= PLAYER_Y;
            velocity_x <= 0;
            velocity_y <= 0;
        end
        else begin
            state <= next_state;
            // 상태에 따른 좌표 업데이트 로직
            case (next_state)
                // 초기 위치 고정
                IDLE: begin
                    ball_x <= PLAYER_X;
                    ball_y <= PLAYER_Y;
                    velocity_x <= 0;
                    velocity_y <= 0;
                end
                FLYING, GOAL: begin
                    // 골대와 충돌 시 반발
                    if (collide_dot(ball_x,ball_y,BALL_RADIUS,GOAL_X_LEFT,GOAL_Y)) begin // 골대 왼쪽 끝과 충돌
                        if (ball_x - GOAL_X_LEFT >= ball_y - GOAL_Y && GOAL_X_LEFT - ball_x <= ball_y - GOAL_Y
                        || ball_x - GOAL_X_LEFT <= ball_y - GOAL_Y && GOAL_X_LEFT - ball_x >= ball_y - GOAL_Y) velocity_x <= -velocity_x; // 좌 우 에서 접근 판별
                        else velocity_y <= -velocity_y; // 아래 위 에서 접근 판별
                    end
                    else if (collide_dot(ball_x,ball_y,BALL_RADIUS,GOAL_X_RIGHT,GOAL_Y)) begin // 골대 오른쪽 끝과 충돌
                        if (ball_x - GOAL_X_RIGHT >= ball_y - GOAL_Y && GOAL_X_RIGHT - ball_x <= ball_y - GOAL_Y
                        || ball_x - GOAL_X_RIGHT <= ball_y - GOAL_Y && GOAL_X_RIGHT - ball_x >= ball_y - GOAL_Y) velocity_x <= -velocity_x; // 좌 우 에서 접근 판별
                        else velocity_y <= -velocity_y; // 아래 위에서 접근 판별
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
                if (btn_throw) begin
                    if (power == 0) begin
                        empowering = 1;
                        power = 1;
                    end
                    else if (tick_200ms) begin
                        if (power == 4'b1111) empowering = 0;
                        else if (power == 1) empowering = 1;
                        if (empowering) power = power + 1;
                        else power = power - 1;
                    end
                end                
                else if (power > 0) begin
                    velocity_x = power * -sw_speed_x;
                    velocity_y = power * -sw_speed_y;
                    power = 0;
                    next_state = FLYING;
                end
                else next_state = IDLE;
            end
            FLYING: begin
                // 바닥에 닿거나 골대에 닿으면 상태 변경
                if (ball_y >= 480 - BALL_RADIUS || ball_x + BALL_RADIUS < 0 ) next_state = IDLE; // 공 넘어감
                else if (collide_line(ball_x, ball_y, BALL_RADIUS, GOAL_X_LEFT, GOAL_X_RIGHT, GOAL_Y) && velocity_y <= 0) begin
                    score = score + 1; // 골 점수
                    velocity_x = velocity_x >>> 1; // 골망 효과 속도 감소
                    velocity_y = velocity_y >>> 1;
                    next_state = GOAL;
                end
                else next_state = FLYING;
            end
            GOAL: begin
                if (ball_y >= 480 - BALL_RADIUS || ball_x + BALL_RADIUS < 0 ) next_state = IDLE; // 공 넘어감
                else next_state = GOAL;
            end
        endcase
    end

endmodule