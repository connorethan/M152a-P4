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
    output latch,
    output nes_clk,
    output [7:0] led,
    output vsync,
    output hsync,
    output red,
    output blue,
    output green
);

nes_controller controller(
    .clk(clk),
    .data(data),
    .latch(latch),
    .nes_clk(nes_clk),
    .abssudlr(led)  
);

wire [31:0] ball_x, ball_y, paddle_x, paddle_y;
game_logic game(
    .gameclk(clk),
    .button(led),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .paddle_x(paddle_x),
    .paddle_y(paddle_y)
);

wire pixel_clk;
clock25mhz pixel_clk_div(
    .clk(clk),
    .enable(pixel_clk)
);

reg [2:0] white = 3'b111;
reg [2:0] black = 3'b000;

wire [15:0] scx, scy;

wire ball_px = (
    ball_x - 5 <= scx && scx <= ball_x + 5 &&
    ball_y - 5 <= scy && scy <= ball_y + 5);
wire paddle_px = (
   paddle_x - 10 <= scx && scx <= paddle_x &&
   paddle_y <= scy && scy <= paddle_y + 50);

wire[2:0] pixel = (ball_px || paddle_px) ? white : black;

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
