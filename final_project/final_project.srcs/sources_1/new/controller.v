`timescale 1ns / 1ps

module nes_controller(
    input wire clk, 
    input wire data,                                        // input data from nes controller to FPGA
    output reg latch = 0, nes_clk = 0,                              // outputs from FPGA to nes controller
    output reg [7:0] abssudlr = 8'b0
);

    wire clockEnable;
    clock60hz clk60hz(clk, clockEnable);
    // states
    localparam [3:0] 
             latch_en = 4'h0,  
             read_data = 4'h1,
             null_state = 4'h2;
    localparam
            clk12us = 1200,
            clk6us = clk12us / 2;  
             
    reg [10:0] count = 0;
    
    reg [3:0] state = null_state; 
    reg [7:0] button_index = 8'd0;
            
 
    always @(posedge clk) begin
        if (clockEnable && (state == null_state)) begin
            state = latch_en;
            count = 0;
        end
        case(state)
        
            latch_en: begin
                if(count >= clk12us) begin
                    latch = 0;
                    if (count >= clk12us + clk6us) begin
                        count = 0;
                        button_index = 8'd1;
                        state = read_data;
                    end else begin 
                        count = count + 1;
                        if (count == clk12us) abssudlr[0] = ~data;
                    end
                end else begin
                    latch = 1;
                    count = count + 1;
                end
            end
        
            read_data: begin
                if(count <= clk6us) begin
                    nes_clk = 1; 
                end else
                    nes_clk = 0;
                
                if(count < clk12us) begin    
                    if(count == clk6us)
                        abssudlr[button_index] = ~data;
                    count = count + 1;
                end else if(count >= clk12us) begin
                    button_index = button_index + 8'd1;
                    
                    if(button_index == 8) begin
                        state = null_state;
                        button_index = 0;
                    end
                    count = 0; 
                end
             
            end
            
            default: begin
                nes_clk = 0;
                latch = 0;
            end
        endcase
    end
    
endmodule
