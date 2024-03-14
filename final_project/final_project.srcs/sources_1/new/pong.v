`timescale 1ns / 1ps

module pong(
    input clk,
    input data1,
    input data2,
    input btn_down,
    input btn_up,
    output latch1,
    output nes_clk1,
    output latch2,
    output nes_clk2,
    output vsync,
    output hsync,
    output red,
    output blue,
    output green
);

wire [0:79] pixel_map;
wire [0:79] pixel_map2;
wire [3:0] width;
wire [3:0] height;
wire [7:0] buttons1;
wire [7:0] buttons2;

nes_controller controller1(
    .clk(clk),
    .data(data1),
    .latch(latch1),
    .nes_clk(nes_clk1),
    .abssudlr(buttons1)  
);

nes_controller controller2(
    .clk(clk),
    .data(data2),
    .latch(latch2),
    .nes_clk(nes_clk2),
    .abssudlr(buttons2)  
);

wire [31:0] ball_x, ball_y;
wire [31:0] paddle1_x, paddle1_top, paddle1_bottom;
wire [31:0] paddle2_x, paddle2_top, paddle2_bottom;
wire [31:0] digit_index1, digit_index2;

game_logic game(
    .gameclk(clk),
    .btn_down1(buttons1[5]),
    .btn_up1(buttons1[4]),
    .start1(buttons1[3]),
    .btn_down2(buttons2[5]),
    .btn_up2(buttons2[4]),
    .start2(buttons2[3]),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .paddle1_x(paddle1_x),
    .paddle1_top(paddle1_top),
    .paddle1_bottom(paddle1_bottom),
    .paddle2_x(paddle2_x),
    .paddle2_top(paddle2_top),
    .paddle2_bottom(paddle2_bottom),
    .digit_index1(digit_index1),
    .digit_index2(digit_index2)
);

wire pixel_clk;
clock25mhz pixel_clk_div(
    .clk(clk),
    .enable(pixel_clk)
);

// Score display parameters
localparam SCORE_SCALE = 4; // Adjust this value to change the score size
wire [31:0] SCORE_WIDTH = width * SCORE_SCALE;
wire [31:0] SCORE_HEIGHT = height * SCORE_SCALE;

localparam [104:0]
    p1_starting_x = 106,
    p1_starting_y = 80,
    p2_starting_x = 530;  // Adjust the starting x-coordinate for paddle 2's score

digit_pixel_map digit_pixel_map(
    .digit_index(digit_index1),
    .pixel_map(pixel_map),
    .width(width),
    .height(height)
);

digit_pixel_map digit_pixel_map2(
    .digit_index(digit_index2),
    .pixel_map(pixel_map2),
    .width(),
    .height()
);

reg [2:0] white = 3'b111;
reg [2:0] black = 3'b000;

wire [15:0] scx, scy;

wire ball_px = (
    ball_x - 5 <= scx && scx <= ball_x + 5 &&
    ball_y - 5 <= scy && scy <= ball_y + 5);

wire paddle1_px = (
    paddle1_x - 10 <= scx && scx <= paddle1_x &&
    paddle1_top <= scy && scy <= paddle1_top + 50);

wire paddle2_px = (
    paddle2_x <= scx && scx <= paddle2_x + 10 &&
    paddle2_top <= scy && scy <= paddle2_top + 50);

wire score1_px = (
    scx >= p1_starting_x && scx < p1_starting_x + SCORE_WIDTH &&
    scy >= p1_starting_y && scy < p1_starting_y + SCORE_HEIGHT &&
    pixel_map[((scx - p1_starting_x) / SCORE_SCALE) + ((scy - p1_starting_y) / SCORE_SCALE) * 8]
);

wire score2_px = (
    scx >= p2_starting_x && scx < p2_starting_x + SCORE_WIDTH &&
    scy >= p1_starting_y && scy < p1_starting_y + SCORE_HEIGHT &&
    pixel_map2[((scx - p2_starting_x) / SCORE_SCALE) + ((scy - p1_starting_y) / SCORE_SCALE) * 8]
);

wire[2:0] pixel = (ball_px || paddle1_px || paddle2_px || score1_px || score2_px) ? white : black;

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
