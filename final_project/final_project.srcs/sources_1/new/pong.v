`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 02:54:36 PM
// Design Name: 
// Module Name: pong
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


module pong(
    input clk,
    input data,
    input btn_down,
    input btn_up,
    output latch,
    output nes_clk,
    output [7:0] led,
    output vsync,
    output hsync,
    output red,
    output blue,
    output green
);

localparam [104:0] 
     p1_starting_x = 106,
     p1_starting_y = 80;

wire [0:79] pixel_map;
wire [3:0] width;
wire [3:0] height;
     
nes_controller controller(
    .clk(clk),
    .data(data),
    .latch(latch),
    .nes_clk(nes_clk),
    .abssudlr(led)  
);

wire [31:0] ball_x, ball_y;
wire [31:0] paddle_x, paddle_top, paddle_bottom;
wire [31:0] digit_index;
game_logic game(
    .gameclk(clk),
    .btn_down(btn_down),
    .btn_up(btn_up),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .paddle_x(paddle_x),
    .paddle_top(paddle_top),
    .paddle_bottom(paddle_bottom),
    .digit_index(digit_index)
);

wire pixel_clk;
clock25mhz pixel_clk_div(
    .clk(clk),
    .enable(pixel_clk)
);

digit_pixel_map digit_pixel_map(
    .digit_index(digit_index),
    .pixel_map(pixel_map),
    .width(width),
    .height(height)
);

reg [2:0] white = 3'b111;
reg [2:0] black = 3'b000;

wire [15:0] scx, scy;

wire ball_px = (
    ball_x - 5 <= scx && scx <= ball_x + 5 &&
    ball_y - 5 <= scy && scy <= ball_y + 5);
wire paddle_px = (
   paddle_x - 10 <= scx && scx <= paddle_x &&
   paddle_top <= scy && scy <= paddle_top + 50);

wire score_px = (
    scx >= p1_starting_x && scx < p1_starting_x + width && 
    scy >= p1_starting_y && scy < p1_starting_y + height &&
    pixel_map[(scx - p1_starting_x) + (scy - p1_starting_y) * 8]
);

wire[2:0] pixel = (ball_px || paddle_px || score_px) ? white : black;

Vga display(
    .pixelClock(pixel_clk),
    .activePixel(pixel),
    .RED(red),
    .GREEN(green),
    .BLUE(blue),
    .HSYNC(hsync),
    .VSYNC(vsync),
    .vSyncStart(),
    .visibleArea(),
    .screenX(scx),
    .screenY(scy)
);

endmodule
