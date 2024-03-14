`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2024 02:02:48 PM
// Design Name: 
// Module Name: paddle
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


module paddle #(
    parameter integer X_POS = 0,
    parameter integer Y_MAX = 48_000,
    parameter integer Y_START = Y_MAX/2,
    parameter integer HALF_WIDTH = 500,
    parameter integer HALF_HEIGHT = 2_500,
    parameter integer BALL_HALF_WIDTH = 500
)(
    input wire gameclk,
    input wire btn_down,
    input wire btn_up,
    input wire [31:0] extra_speed,
    input wire [31:0] ball_x,
    input wire [31:0] ball_y,
    input wire rst,
    output wire [31:0] top,
    output wire [31:0] bottom,
    output wire [31:0] left,
    output wire [31:0] right,
    output wire ball_collides,
    output reg [31:0] ball_tick_max_x,
    output reg [31:0] ball_tick_max_y,
    output reg [31:0] vel_y
);

reg [31:0] paddle_y = Y_START;

assign top = paddle_y - HALF_HEIGHT;
assign bottom = paddle_y + HALF_HEIGHT;
assign left = X_POS - HALF_WIDTH;
assign right = X_POS + HALF_WIDTH;

assign ball_collides = (left <= ball_x + BALL_HALF_WIDTH)
    && (ball_x - BALL_HALF_WIDTH <= right)
    && (top <= ball_y + BALL_HALF_WIDTH)
    && (ball_y - BALL_HALF_WIDTH <= bottom);

reg [31:0] paddle_tick_count = 1;
reg [31:0] paddle_tick_max = 100_000_000 / 10_000;

reg [31:0] bounce_dist = 0;

always @(posedge gameclk) begin
    if (paddle_tick_count + extra_speed >= paddle_tick_max) begin
        paddle_tick_count = 1;
        if (btn_down && btn_up) begin
            // Do nothing
        end else if (btn_down) begin
            if (bottom < Y_MAX) paddle_y = paddle_y + 1;
        end else if (btn_up) begin
            if (top > 0) paddle_y = paddle_y - 1;
        end
    end else begin
        paddle_tick_count = paddle_tick_count + 1;
    end

    // Ball bounce computation
    if (ball_y + 100 < paddle_y) begin
        bounce_dist = (paddle_y - ball_y);
        vel_y = -1;
        ball_tick_max_y = 100_000_000 / (bounce_dist * 4);
        ball_tick_max_x = 100_000_000 / (
            10_000 - 11 * bounce_dist * bounce_dist / 10_000);
    end else if (ball_y > paddle_y + 100) begin
        bounce_dist = (ball_y - paddle_y);
        vel_y = 1;
        ball_tick_max_y = 100_000_000 / (bounce_dist * 4);
        ball_tick_max_x = 100_000_000 / (
            10_000 - 11 * bounce_dist * bounce_dist / 10_000);
    end else begin
        vel_y = 0;
        ball_tick_max_x = 100_000_000 / 10_000;
    end
    
    if(rst) begin
        paddle_y = Y_START;
    end
end

endmodule
