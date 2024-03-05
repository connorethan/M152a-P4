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
    output [7:0] led
);

nes_controller controller(
    .clk(clk),
    .data(data),
    .latch(latch),
    .nes_clk(nes_clk),
    .abssudlr(led)
    
);

endmodule
