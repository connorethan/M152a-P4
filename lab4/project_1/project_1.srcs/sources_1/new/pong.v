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
    input reset,
    input data,
    output [15:0] led
);

controller nes(
    .clk(clk),
    .reset(reset),
    .data(data),
    .A(led[0]),
    .B(),
    .select(),
    .start(),
    .up(),
    .down(),
    .left(),
    .right()
);

endmodule
