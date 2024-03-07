`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2024 10:58:23 PM
// Design Name: 
// Module Name: controller_tb
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


module controller_tb;

reg clk = 0;
reg data = 0;
wire latch;
wire nes_clk;
wire [7:0] abssudlr;


nes_controller controller(
    .clk(clk),
    .data(data),
    .latch(latch),
    .nes_clk(nes_clk),
    .abssudlr(abssudlr)    
);

integer j = 0;
initial begin
    clk = 0;
    
    for (j = 0; j < 10000; j = j + 1) begin
        tick_data();
        tick5();
    end
end

integer i = 0;
task tick5(); begin
    #1
    clk = ~clk;
    for (i = 0; i < 5; i = i + 1) begin
        #1
        clk = ~clk;
    end
end endtask

integer data_flip_count = 0;
task tick_data(); begin
    if (data_flip_count >= 2) begin
        data = ~data;
        data_flip_count = 0;
    end else begin
        data_flip_count = data_flip_count + 1;
    end
end endtask

endmodule
