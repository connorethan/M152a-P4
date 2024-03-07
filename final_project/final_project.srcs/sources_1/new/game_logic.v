module game_logic(
    input gameclk,
    input[7:0] button,
    output wire [31:0] ball_x,
    output wire [31:0] ball_y,
    output wire [31:0] paddle_x,
    output wire [31:0] paddle_y,
    output wire [31:0] digit_index
);
 
/**
 * Screen is 640x480; coordinate space is 64,000x48,000
 * [precision is 100:1]
 * Divide by 100 to get pixel coordinate
 */
localparam X_MAX = 64_000, Y_MAX = 48_000;

// Ball constants
localparam BALL_START_X = X_MAX/2, BALL_START_Y = Y_MAX/2;

// Ball data
reg[31:0] ballX = BALL_START_X, ballY = BALL_START_Y, velX = 1, velY = 1;
reg[31:0] ball_tick_count_x = 1, ball_tick_max_x = 100_000_000 / 10_000;
reg[31:0] ball_tick_count_y = 1, ball_tick_max_y = 100_000_000 / 10_000;

// Paddle constants
localparam 
    PADDLE_X = 8_000;
   

// Paddle data
reg[31:0] paddle_top = 5_000, paddle_bottom = 10_000;
reg[31:0] paddle_tick_count = 1, paddle_tick_max = 100_000_000 / 10_000;


// Score
reg[31:0] p1_score = 0;

// Output data
assign ball_x = ballX / 100;
assign ball_y = ballY / 100;
assign paddle_x = PADDLE_X / 100;
assign paddle_y = paddle_top / 100;
assign digit_index = p1_score;

always @(posedge gameclk) begin
    // Ball movement handling
    if (ball_tick_count_y == ball_tick_max_y) begin
        ball_tick_count_y = 1;
        ballY = ballY + velY;
        
        if (ballY == 0) begin // Top of screen
            velY = 1;
        end else if (ballY == Y_MAX) begin // Bottom
            velY = -1;
        end
    end else begin
        ball_tick_count_y = ball_tick_count_y + 1;
    end
    if (ball_tick_count_x == ball_tick_max_x) begin
        ball_tick_count_x = 1;
        ballX = ballX + velX;

        if (ballX == 0) begin // Left side
            velX = 1;
        end else if (ballX == X_MAX) begin // Right side
            velX = -1;
            p1_score = p1_score + 1;
            if (p1_score > 6) begin
                p1_score = 0;
            end
        end
        
        if (ballX == PADDLE_X && (paddle_top <= ballY && ballY <= paddle_bottom)) begin // Paddle
            velX = 1;
        end
    end else begin
        ball_tick_count_x = ball_tick_count_x + 1;
    end
    
    if (paddle_tick_count == paddle_tick_max) begin
        paddle_tick_count = 1;
        //if (button[4] && button[5]) begin
            // Do nothing
        //end else
        if (button[5]) begin // Down
            if (paddle_bottom < Y_MAX) begin
                paddle_bottom = paddle_bottom + 1;
                paddle_top = paddle_top + 1;
            end
        end else if (button[4]) begin // Up
            if (paddle_top > 0) begin
                paddle_bottom = paddle_bottom - 1;
                paddle_top = paddle_top - 1;
            end
        end 
    end else begin
        paddle_tick_count = paddle_tick_count + 1;
    end
end

/**
 * Paddle collision with top/bottom of screen
 * Ball vs paddle collision + reflection //
 */

endmodule
