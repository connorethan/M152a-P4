module game_logic(
    input gameclk,
    input btn_down,
    input btn_up,
    output wire [31:0] ball_x,
    output wire [31:0] ball_y,
    output wire [31:0] paddle1_x,
    output wire [31:0] paddle1_top,
    output wire [31:0] paddle1_bottom,
    output wire [31:0] paddle2_x,
    output wire [31:0] paddle2_top,
    output wire [31:0] paddle2_bottom,
    output wire [31:0] digit_index1,
    output wire [31:0] digit_index2
);

localparam X_MAX = 64_000, Y_MAX = 48_000;
localparam BALL_START_X = X_MAX/2, BALL_START_Y = Y_MAX/2;
localparam BALL_HALF_WIDTH = 500;
localparam
    LEFT_BORDER = BALL_HALF_WIDTH,
    RIGHT_BORDER = X_MAX - BALL_HALF_WIDTH,
    TOP_BORDER = BALL_HALF_WIDTH,
    BOTTOM_BORDER = Y_MAX - BALL_HALF_WIDTH;

reg[31:0] ballX = BALL_START_X, ballY = BALL_START_Y, velX = 1, velY = 1;
reg[31:0] ball_tick_count_x = 1, ball_tick_max_x = 100_000_000 / 10_000;
reg[31:0] ball_tick_count_y = 1, ball_tick_max_y = 100_000_000 / 10_000;
reg[31:0] extra_speed = 0;

localparam PADDLE_X1 = 8_000, PADDLE_X2 = 56_000, PADDLE_HALF_HEIGHT = 2_500;

reg[31:0] paddle1_y = BALL_START_Y, paddle2_y = BALL_START_Y;
reg[31:0] paddle_tick_count = 1, paddle_tick_max = 100_000_000 / 10_000;

wire [31:0] paddle1_high, paddle1_low, paddle2_high, paddle2_low;
assign paddle1_high = (paddle1_y - PADDLE_HALF_HEIGHT);
assign paddle1_low = (paddle1_y + PADDLE_HALF_HEIGHT);
assign paddle2_high = (paddle2_y - PADDLE_HALF_HEIGHT);
assign paddle2_low = (paddle2_y + PADDLE_HALF_HEIGHT);

reg[31:0] p1_score = 0, p2_score = 0;
localparam MAX_SCORE = 6;

assign ball_x = ballX / 100;
assign ball_y = ballY / 100;
assign paddle1_x = PADDLE_X1 / 100;
assign paddle1_top = paddle1_high / 100;
assign paddle1_bottom = paddle1_low / 100;
assign paddle2_x = PADDLE_X2 / 100;
assign paddle2_top = paddle2_high / 100;
assign paddle2_bottom = paddle2_low / 100;
assign digit_index1 = p1_score;
assign digit_index2 = p2_score;

always @(posedge gameclk) begin
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
        if (ballX - BALL_HALF_WIDTH == PADDLE_X1 && (paddle1_high <= ballY && ballY <= paddle1_low)) begin
            velX = 1;
            extra_speed = extra_speed + 1000;
        end else if (ballX + BALL_HALF_WIDTH == PADDLE_X2 && (paddle2_high <= ballY && ballY <= paddle2_low)) begin
            velX = -1;
            extra_speed = extra_speed + 1000;
        end else if (ballX == LEFT_BORDER) begin // Left side
            ballX = BALL_START_X;
            ballY = BALL_START_Y;
            velX = 1;
            extra_speed = 0;
            p2_score = p2_score + 1;
        end else if (ballX == RIGHT_BORDER) begin // Right side
            ballX = BALL_START_X;
            ballY = BALL_START_Y;
            velX = -1;
            extra_speed = 0;
            p1_score = p1_score + 1;
        end
    end else begin
        ball_tick_count_x = ball_tick_count_x + 1;
    end
    
    if (paddle_tick_count + extra_speed >= paddle_tick_max) begin
            paddle_tick_count = 1;
            if (btn_down) begin
                if (paddle1_low < Y_MAX && paddle2_low < Y_MAX) begin
                    paddle1_y = paddle1_y + 1;
                    paddle2_y = paddle2_y + 1;
                end
            end else if (btn_up) begin
                if (paddle1_high > 0 && paddle2_high > 0) begin
                    paddle1_y = paddle1_y - 1;
                    paddle2_y = paddle2_y - 1;
                end
            end
        end else begin
            paddle_tick_count = paddle_tick_count + 1;
        end
    
        // Collision detection
        if (ballX - BALL_HALF_WIDTH == PADDLE_X1 && (paddle1_high <= ballY && ballY <= paddle1_low)) begin
            velX = 1;
            extra_speed = extra_speed + 1000;
        end else if (ballX + BALL_HALF_WIDTH == PADDLE_X2 && (paddle2_high <= ballY && ballY <= paddle2_low)) begin
            velX = -1;
            extra_speed = extra_speed + 1000;
        end
end

/**
 * Paddle collision with top/bottom of screen
 * Ball vs paddle collision + reflection //
 */

endmodule