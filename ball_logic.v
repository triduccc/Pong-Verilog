module ball_logic(
    input clk,
    input rst,
    input [9:0] paddle1_y, 
    input [9:0] paddle2_y, 
    output reg signed [9:0] ball_x,
    output reg signed [9:0] ball_y,
    output reg [3:0] score_p1,
    output reg [3:0] score_p2
);

    // Parameters
    parameter X_MAX = 80;
    parameter Y_MAX = 24;
    parameter PADDLE_HEIGHT = 4; 
    parameter PADDLE_WIDTH = 1; 
    parameter BALL_SIZE = 1;      

    // Game variables
    reg signed [9:0] ball_dx; 
    reg signed [9:0] ball_dy; 
    reg [9:0] new_ball_x, new_ball_y;
    reg [9:0] ball_x_next, ball_y_next;
    reg signed [9:0] ball_dx_next, ball_dy_next;

    // Initialize positions
    initial begin
        ball_x = X_MAX / 2;
        ball_y = Y_MAX / 2;
        ball_dx = 1; 
        ball_dy = 1;
        score_p1 = 0;
        score_p2 = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset everything
            ball_x <= X_MAX / 2;
            ball_y <= Y_MAX / 2;
            ball_dx <= 1;
            ball_dy <= 1;

        end 
        else begin  // opens the game loop
            
            // Update Ball Position
            ball_x = ball_x + ball_dx;
            ball_y = ball_y + ball_dy;

            // top/bottom bounce
            if (ball_y <= BALL_SIZE || ball_y >= Y_MAX - BALL_SIZE) begin
                ball_dy = -ball_dy;
                ball_y = (ball_y <= BALL_SIZE) ? BALL_SIZE + 1 : Y_MAX- (BALL_SIZE + 1);
            end

            // Left paddle hit
            if (ball_x == PADDLE_WIDTH + 1 && ball_dx == -1) begin
                if (ball_y >= paddle1_y && ball_y < paddle2_y + PADDLE_HEIGHT) begin
                    ball_dx = 1;
                    // Add spin based on where it hit
                    if (ball_y < paddle1_y + PADDLE_HEIGHT/2)
                        ball_dy = ball_dy - 1;
                    else
                        ball_dy = ball_dy + 1;
                end
            end

            // Right paddle hit
            if (ball_x == X_MAX - PADDLE_WIDTH && ball_dx == 1) begin
                if (ball_y >= paddle2_y && ball_y < paddle2_y + PADDLE_HEIGHT) begin
                    ball_dx = -1;
                    if (ball_y < paddle2_y + PADDLE_HEIGHT/2)
                        ball_dy = ball_dy - 1;
                    else
                        ball_dy = ball_dy + 1;
                end
            end

            // Score!
            if (ball_x < PADDLE_WIDTH + 1) begin
                score_p1 = score_p1 + 1;
                ball_x = X_MAX / 2;
                ball_y = Y_MAX / 2;
                ball_dx = 1;  // Or -ball_dx to reverse, or randomize
                ball_dy = 1; 
            end
            if (ball_x > X_MAX - PADDLE_WIDTH) begin
                score_p2 = score_p2 + 1;
                ball_x = X_MAX / 2;
                ball_y = Y_MAX / 2;
                ball_dx = -1;  // Reverse direction
                ball_dy = 1;
            end


        end // <--- THIS 'END' CLOSES THE 'ELSE BEGIN' (Game Loop)
    end // <--- THIS 'END' CLOSES THE 'ALWAYS' BLOCK

endmodule // <--- CRITICAL: DO NOT DELETE THIS LINE
