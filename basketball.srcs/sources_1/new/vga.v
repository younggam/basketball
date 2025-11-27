`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/27 23:30:04
// Design Name: 
// Module Name: vga
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

module vga (
    input wire pixel_clk,           // 픽셀 클럭 (25MHz 권장 for 640x480)
    input wire resetn,         // 리셋 (Active Low)
    output wire hsync,        // 수평 동기 신호
    output wire vsync,        // 수직 동기 신호
    output wire [9:0] pixel_x,// 현재 픽셀 X 좌표 (0~639)
    output wire [9:0] pixel_y,// 현재 픽셀 Y 좌표 (0~479)
    output wire video_on      // 화면 표시 구간 (Active High)
);

    // VGA 640x480 @ 60Hz 타이밍 표준 파라미터
    // Horizontal parameters (단위: 픽셀 클럭)
    localparam HD = 640; // Horizontal Display (화면 영역)
    localparam HF = 16;  // Horizontal Front Porch
    localparam HB = 48;  // Horizontal Back Porch
    localparam HR = 96;  // Horizontal Retrace (Sync Pulse)
    localparam H_TOTAL = HD + HF + HB + HR; // 800

    // Vertical parameters (단위: 라인)
    localparam VD = 480; // Vertical Display (화면 영역)
    localparam VF = 10;  // Vertical Front Porch
    localparam VB = 33;  // Vertical Back Porch
    localparam VR = 2;   // Vertical Retrace (Sync Pulse)
    localparam V_TOTAL = VD + VF + VB + VR; // 525

    // 카운터 레지스터
    reg [9:0] h_count_reg, h_count_next;
    reg [9:0] v_count_reg, v_count_next;

    // 출력 버퍼 레지스터 (Glitch 방지용)
    reg v_sync_reg, h_sync_reg;
    wire v_sync_next, h_sync_next;

    // 1. 카운터 로직 (Pixel Counting)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            h_count_reg <= 0;
            v_count_reg <= 0;
            v_sync_reg <= 1'b1;
            h_sync_reg <= 1'b1;
        end else begin
            h_count_reg <= h_count_next;
            v_count_reg <= v_count_next;
            v_sync_reg <= v_sync_next;
            h_sync_reg <= h_sync_next;
        end
    end

    // 2. Next State Logic
    always @(*) begin
        // 수평 카운터: 799에 도달하면 0으로 리셋
        if (h_count_reg == H_TOTAL - 1)
            h_count_next = 0;
        else
            h_count_next = h_count_reg + 1;

        // 수직 카운터: 수평 카운터가 한 바퀴 돌았을 때 증가
        if (h_count_reg == H_TOTAL - 1) begin
            if (v_count_reg == V_TOTAL - 1)
                v_count_next = 0;
            else
                v_count_next = v_count_reg + 1;
        end else begin
            v_count_next = v_count_reg;
        end
    end

    // 3. 동기 신호 생성 (Active Low)
    // 수평 동기: Display + Front Porch 이후 Sync Pulse 구간에서 Low
    assign h_sync_next = (h_count_reg >= (HD + HF) && h_count_reg <= (HD + HF + HR - 1)) ? 1'b0 : 1'b1;
    
    // 수직 동기: Display + Front Porch 이후 Sync Pulse 구간에서 Low
    assign v_sync_next = (v_count_reg >= (VD + VF) && v_count_reg <= (VD + VF + VR - 1)) ? 1'b0 : 1'b1;

    // 4. 출력 신호 할당
    assign hsync = h_sync_reg;
    assign vsync = v_sync_reg;
    
    // 현재 좌표 출력 (화면 영역 안일 때만 유효 좌표, 그 외에는 0 또는 무시)
    assign pixel_x = (h_count_reg < HD) ? h_count_reg : 10'd0;
    assign pixel_y = (v_count_reg < VD) ? v_count_reg : 10'd0;

    // Video On 신호: 현재 스캔 위치가 화면 영역(Display Area) 안에 있을 때 High
    assign video_on = (h_count_reg < HD) && (v_count_reg < VD);

endmodule
