module game_logic(
    input gameclk,
    input btn_down1,
    input btn_up1,
    input start1,
    input btn_down2,
    input btn_up2,
    input start2,
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

reg[31:0] ballX = BALL_START_X, ballY = BALL_START_Y, velX = 1, velY = 0;
reg[31:0] ball_tick_count_x = 1, ball_tick_max_x = 100_000_000 / 10_000;
reg[31:0] ball_tick_count_y = 1, ball_tick_max_y = 100_000_000 / 10_000;
reg[31:0] extra_speed = 0;

wire ball_collides_paddle1;
wire [31:0] ball_tick_max_x1, ball_tick_max_y1, vel_y1;
wire [31:0] paddle1_high, paddle1_low, paddle1_x_inner;
paddle #(8_000) paddle1 (
    .gameclk(gameclk),
    .btn_down(btn_down1),
    .btn_up(btn_up1),
    .extra_speed(extra_speed),
    .ball_x(ballX),
    .ball_y(ballY),
    .rst(rst),
    .top(paddle1_high),
    .bottom(paddle1_low),
    .left(),
    .right(paddle1_x_inner),
    .ball_collides(ball_collides_paddle1),
    .ball_tick_max_x(ball_tick_max_x1),
    .ball_tick_max_y(ball_tick_max_y1),
    .vel_y(vel_y1)
);

wire ball_collides_paddle2, rst;
wire [31:0] ball_tick_max_x2, ball_tick_max_y2, vel_y2;
wire [31:0] paddle2_high, paddle2_low, paddle2_x_inner;
paddle #(56_000) paddle2 (
    .gameclk(gameclk),
    .btn_down(btn_down2),
    .btn_up(btn_up2),
    .extra_speed(extra_speed),
    .ball_x(ballX),
    .ball_y(ballY),
    .rst(rst),
    .top(paddle2_high),
    .bottom(paddle2_low),
    .left(paddle2_x_inner),
    .right(),
    .ball_collides(ball_collides_paddle2),
    .ball_tick_max_x(ball_tick_max_x2),
    .ball_tick_max_y(ball_tick_max_y2),
    .vel_y(vel_y2)
);

reg[31:0] p1_score = 0, p2_score = 0;
localparam MAX_SCORE = 6;

assign ball_x = ballX / 100;
assign ball_y = ballY / 100;
assign paddle1_x = paddle1_x_inner / 100;
assign paddle1_top = paddle1_high / 100;
assign paddle1_bottom = paddle1_low / 100;
assign paddle2_x = paddle2_x_inner / 100;
assign paddle2_top = paddle2_high / 100;
assign paddle2_bottom = paddle2_low / 100;
assign digit_index1 = p1_score;
assign digit_index2 = p2_score;
assign rst = (p1_score >= 6 || p2_score >= 6 || start1 || start2); 

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
        if (ball_collides_paddle1) begin // Paddle 1
            if (extra_speed < 10000) extra_speed = extra_speed + 1000;
            ball_tick_max_x = ball_tick_max_x1;
            ball_tick_max_y = ball_tick_max_y1;
            velX = 1;
            velY = vel_y1;
        end else if (ball_collides_paddle2) begin // Paddle 2
            if (extra_speed < 10000) extra_speed = extra_speed + 1000;
            ball_tick_max_x = ball_tick_max_x2;
            ball_tick_max_y = ball_tick_max_y2;
            velX = -1;
            velY = vel_y2;
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
    
    if (rst) begin
        ballX = BALL_START_X;
        ballY = BALL_START_Y;
        velX = 1;
        velY = 0;
        extra_speed = 0;
        p1_score = 0;
        p2_score = 0;
        ball_tick_max_x = 100_000_000 / 10_000;
        ball_tick_max_y = 100_000_000 / 10_000;
        
    end
end

endmodule
