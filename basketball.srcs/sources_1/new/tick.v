`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/27 21:06:57
// Design Name: 
// Module Name: tick
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


module tick#(
    parameter CNT_1MS=100000
)(
    input wire clk,
    input wire resetn,
    output reg tick_1ms,
    output reg tick_50ms // 게임 업데이트용 클럭 20Hz
);
    reg [31:0] cnt_clk;
    reg [5:0] cnt_50ms;
    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            cnt_clk <= 0;
            tick_1ms <= 0;
        end
        else begin
            if (cnt_clk == (CNT_1MS-1)) begin
                cnt_clk <= 0;
                tick_1ms <= 1;
            end
            else begin
                cnt_clk <= cnt_clk + 1;
                tick_1ms <= 0;
            end
        end
    end
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            cnt_50ms <= 0;
            tick_50ms <= 0;
        end
        else begin
            if (tick_1ms)
                if (cnt_50ms == 49) begin
                    cnt_50ms <= 0;
                    tick_50ms <= 1;
                end
                else cnt_50ms <= cnt_50ms + 1;
            else tick_50ms <= 0;
        end
    end
endmodule
