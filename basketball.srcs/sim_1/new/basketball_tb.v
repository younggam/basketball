`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/29 21:50:44
// Design Name: 
// Module Name: basketball_tb
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


module basketball_tb;
    reg clk;
    reg resetn;
    reg btn_throw;
    wire [7:0] digit, seg_data;
    
    initial begin
        clk=0;
        resetn=0;
        btn_throw=0;
        #100 resetn=1;
        forever begin
            btn_throw=1;
            #50000;
            btn_throw=0;
            #100000;
        end
    end
    
    initial begin
        clk=0;
        forever #1 clk=~clk;
    end
    
    basketball#(
        .CNT_1MS(50000),
        .GRAVITY(1),
        .GOAL_X_LEFT(20),
        .GOAL_X_RIGHT(100),
        .GOAL_Y(100),
        .BALL_RADIUS(12),
        .PLAYER_X(600),
        .PLAYER_Y(360)
    )dut(
        .clk(clk),
        .resetn(resetn),
        .sw_speed_x(8),
        .sw_speed_y(8),
        .btn_throw(btn_throw),
        .digit(digit),
        .seg_data(seg_data),
        .red(),
        .green(),
        .blue(),
        .hsync(),
        .vsync()
    );
endmodule

