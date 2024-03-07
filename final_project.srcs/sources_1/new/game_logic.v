module game_logic(
    input gameclk,
    input btn_down,
    input btn_up,
    output wire [31:0] ball_x,
    output wire [31:0] ball_y,
    output wire [31:0] paddle_x,
    output wire [31:0] paddle_top,
    output wire [31:0] paddle_bottom,
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
localparam BALL_HALF_WIDTH = 500;
localparam
    LEFT_BORDER = BALL_HALF_WIDTH,
    RIGHT_BORDER = X_MAX - BALL_HALF_WIDTH,
    TOP_BORDER = BALL_HALF_WIDTH,
    BOTTOM_BORDER = Y_MAX - BALL_HALF_WIDTH;

// Ball data
reg[31:0] ballX = BALL_START_X, ballY = BALL_START_Y, velX = 1, velY = 1;
reg[31:0] ball_tick_count_x = 1, ball_tick_max_x = 100_000_000 / 10_000;
reg[31:0] ball_tick_count_y = 1, ball_tick_max_y = 100_000_000 / 10_000;
reg[31:0] extra_speed = 0;

// Paddle constants
localparam PADDLE_X = 8_000, PADDLE_HALF_HEIGHT = 2_500;

// Paddle data
reg[31:0] paddle_y = BALL_START_Y + 10_000;
reg[31:0] paddle_tick_count = 1, paddle_tick_max = 100_000_000 / 10_000;

wire paddle_high = (paddle_y - PADDLE_HALF_HEIGHT);
wire paddle_low = (paddle_y + PADDLE_HALF_HEIGHT);


// Score
reg[31:0] p1_score = 0;
localparam
    MAX_SCORE = 6;

// Output data
assign ball_x = ballX / 100;
assign ball_y = ballY / 100;
assign paddle_x = PADDLE_X / 100;
assign paddle_top = paddle_high / 100;
assign paddle_bottom = paddle_low / 100;
assign digit_index = p1_score;

always @(posedge gameclk) begin
    // Ball movement handling
    if (ball_tick_count_y + extra_speed >= ball_tick_max_y) begin
        ball_tick_count_y = 1;
        ballY = ballY + velY;
        
        if (ballY == TOP_BORDER) begin // Top of screen
            velY = 1;
        end else if (ballY == BOTTOM_BORDER) begin // Bottom
            velY = -1;
        end
    end else begin
        ball_tick_count_y = ball_tick_count_y + 1;
    end
    if (ball_tick_count_x + extra_speed >= ball_tick_max_x) begin
        ball_tick_count_x = 1;
        ballX = ballX + velX;

        if (ballX == LEFT_BORDER) begin // Left side
            velX = 1;
        end else if (ballX == RIGHT_BORDER) begin // Right side
            velX = -1;
            p1_score = p1_score + 1;
            if (p1_score > 6) begin 
                p1_score = 0;       
            end                     
        end

        if (ballX - BALL_HALF_WIDTH == PADDLE_X &&
           (paddle_high <= ballY && ballY <= paddle_low))
        begin // Paddle
            velX = 1;
            extra_speed = extra_speed + 1000;
        end
    end else begin
        ball_tick_count_x = ball_tick_count_x + 1;
    end
    
    if (paddle_tick_count + extra_speed >= paddle_tick_max) begin
        paddle_tick_count = 1;
        if (btn_down && btn_up) begin
            // Do nothing
        end else if (btn_down) begin // Down
            if (paddle_low < Y_MAX) begin
                paddle_y = paddle_y + 1;
            end
        end else if (btn_up) begin // Up
            if (paddle_high > 0) begin
                paddle_y = paddle_y - 1;
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
