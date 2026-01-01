module ball_logic(
    input clk,
    input rst,
    input [9:0] paddle1_y, 
    input [9:0] paddle2_y, 
    output reg [9:0] ball_x,
    output reg [9:0] ball_y,
    output reg [3:0] score_p1,
    output reg [3:0] score_p2
);

    // Parameters
    parameter X_MAX = 639;
    parameter Y_MAX = 479;
    parameter PADDLE_HEIGHT = 40; 
    parameter BALL_SIZE = 8;      

    // Game variables
    reg signed [9:0] ball_dx; 
    reg signed [9:0] ball_dy; 

    // Initialize positions
    initial begin
        ball_x = X_MAX / 2;
        ball_y = Y_MAX / 2;
        ball_dx = 2; 
        ball_dy = 2;
        score_p1 = 0;
        score_p2 = 0;
    end

    // --- MAIN LOGIC STARTS HERE ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset everything
            ball_x <= X_MAX / 2;
            ball_y <= Y_MAX / 2;
            ball_dx <= 2;
            ball_dy <= 2;
            score_p1 <= 0;
            score_p2 <= 0;
        end 
        else begin  // <--- THIS 'BEGIN' OPENS THE GAME LOOP
            
            // 1. Update Ball Position
            ball_x <= ball_x + ball_dx;
            ball_y <= ball_y + ball_dy;

            // 2. Vertical Bounce (Top / Bottom walls)
            if (ball_y <= 0) begin
                ball_y <= 0;
                ball_dy <= -ball_dy; 
            end else if (ball_y >= Y_MAX - BALL_SIZE) begin
                ball_y <= Y_MAX - BALL_SIZE;
                ball_dy <= -ball_dy; 
            end

            // 3. Paddle Collision Logic
            // Paddle 1 (Left Side)
            if (ball_dx < 0 && (ball_x >= 30 && ball_x <= 34)) begin
                if (ball_y + BALL_SIZE >= paddle1_y && ball_y < paddle1_y + PADDLE_HEIGHT) begin
                    ball_dx <= -ball_dx; 
                end
            end
            
            // Paddle 2 (Right Side)
            if (ball_dx > 0 && (ball_x >= 600 && ball_x <= 604)) begin
                if (ball_y + BALL_SIZE >= paddle2_y && ball_y < paddle2_y + PADDLE_HEIGHT) begin
                    ball_dx <= -ball_dx; 
                end
            end

            // 4. Scoring Logic (Left/Right Walls)
            if (ball_x >= X_MAX - BALL_SIZE) begin
                score_p1 <= score_p1 + 1;
                ball_x <= X_MAX / 2;
                ball_y <= Y_MAX / 2;
                ball_dx <= -ball_dx; 
            end
            else if (ball_x <= 0) begin
                score_p2 <= score_p2 + 1;
                ball_x <= X_MAX / 2;
                ball_y <= Y_MAX / 2;
                ball_dx <= -ball_dx; 
            end

        end // <--- THIS 'END' CLOSES THE 'ELSE BEGIN' (Game Loop)
    end // <--- THIS 'END' CLOSES THE 'ALWAYS' BLOCK

endmodule // <--- CRITICAL: DO NOT DELETE THIS LINE