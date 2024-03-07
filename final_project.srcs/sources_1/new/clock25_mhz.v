`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2024 03:59:26 PM
// Design Name: 
// Module Name: clock60hz
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


module clock25mhz(
    input clk,
    output reg enable  
);

reg [26:0] counter = 0; 
parameter DIVIDE_BY = 100_000_000 / 25_000_000;

always @(posedge clk) begin
    if(counter >= DIVIDE_BY) begin
        counter <= 1;
        enable <= 1;  
    end
    else begin
        counter <= counter + 1;
        enable <= 0;
    end
end

endmodule
