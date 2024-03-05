module game_logic(
    input gameclk,
    input[7:0] button
);

/**
 * Screen is 800x600; coordinate space is 80,000x60,000
 * [precision is 100:1]
 * Divide by 100 to get pixel coordinate
 */
localparam X_MAX = 80_000, Y_MAX = 60_000;

// Ball constants
localparam BALL_START_X = X_MAX/2, BALL_START_Y = Y_MAX/2;

// Ball data
reg[31:0] ballX, ballY, velX, velY;
reg[31:0] ball_tick_count, ball_tick_max;

// Paddle constants
localparam PADDLE_X = 200;

// Paddle data
reg[31:0] paddle_bottom, paddle_top;
reg[31:0] paddle_tick_count, paddle_tick_max;

always @(posedge gameclk) begin
    // Ball movement handling
    if (ball_tick_count == ball_tick_max) begin
        ball_tick_count = 1;
        ballX = ballX + velX;
        ballY = ballY + velY;
        
        if (ballX == 0) begin // Left side of screen
            ballX = BALL_START_X;
            ballY = BALL_START_Y;
        end else if (ballX == X_MAX) begin // Right side
            velX = -1;
        end

        if (ballY == 0) begin // Top of screen
            velY = 1;
        end else if (ballY == Y_MAX) begin // Bottom
            velY = -1;
        end
        
        if (ballX == PADDLE_X && (paddle_bottom <= ballY && ballY <= paddle_top)) begin // Paddle
            velX = 1;
        end
    end else begin
        ball_tick_count = ball_tick_count + 1;
    end
    
    if (paddle_tick_count == paddle_tick_max) begin
        if (button[4] && button[5]) begin
            // Do nothing
        end else if (button[4]) begin // Up
            if (paddle_top > 0) begin
                paddle_bottom = paddle_bottom - 1;
                paddle_top = paddle_top - 1;
            end
        end else if (button[5]) begin // Down
            if (paddle_bottom < Y_MAX) begin
                paddle_bottom = paddle_bottom + 1;
                paddle_top = paddle_top + 1;
            end
        end
    end
end

/**
 * Paddle collision with top/bottom of screen
 * Ball vs paddle collision + reflection //
 */

endmodule
