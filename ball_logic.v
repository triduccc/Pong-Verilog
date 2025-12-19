module ball_logic(
    input clk,
    input rst,
    input paddle1_y,
    input paddle2_y,
    output ball_x,
    output ball_y
);

//outout ball pos, score, add input paddle pos

//Parameters
parameter X_MAX = 639;
parameter Y_MAX = 479;

//Game registers
reg [9:0] paddle1_y; //Paddle 1 top position
reg [9:0] paddle2_y; //Paddle 2 top position
reg [9:0] ball_x; //Ball x coordinate
reg [9:0] ball_y; //Ball y coordinate
reg [3:0] score_p1; //1st player score
reg [3:0] score_p2 //2nd player score

reg signed [9:0] ball_dx; //Ball x direction
reg signed [9:0] ball_dy //Ball y direction

//Initialize the position
initial begin
    ball_x = X_MAX / 2;
    ball_y = Y_MAX / 2;
    ball_dx = 1;
    ball_dy = 1;
    paddle1_y = (Y_MAX - 0) / 2; //Replace 0 with paddle height
    paddle2_y = (Y_MAX - 0) / 2; //Replace 0 with paddle height
    score_p1 = 0;
    score_p2 = 0;
end

//Ball logic
always @(posedge clk or posedge rst) begin
    if (rst) begin //Reset everything in the game
        ball_x <= X_MAX / 2;
        ball_y <= Y_MAX / 2;
        ball_dx <= 1;
        ball_dy <= 1;
        paddle1_y <= (Y_MAX - 0) / 2; //Replace 0 with paddle height
        paddle2_y <= (Y_MAX - 0) / 2; //Replace 0 with paddle height
        score_p1 <= 0;
        score_p2 <= 0;
    end
    else begin

        ball_x <= ball_x + ball_dx; //update ball x
        ball_y <= ball_y + ball_dy; //update ball y

        if (ball_y == 0 || ball_y == Y_MAX - 1)
            ball_dy <= -ball_dy; //Change y direction
        
        if (ball_x == 1 && ball_y >= paddle1_y && ball_y < paddle1_y + 0)
            ball_dx <= 1; // Bounce off paddle 1
        else if (ball_x == WIDTH - 2 && ball_y >= paddle2_y && ball_y < paddle2_y + 0)
            ball_dx <= -1; // Bounce off player 2 paddle

        // Score points and reset ball
        if (ball_x >= WIDTH) begin
            score_p1 <= score_p1 + 1;
            ball_x <= WIDTH / 2;
            ball_y <= HEIGHT / 2;
            ball_dx <= -1;
            end
        if (ball_x <= 0) begin
            score_p2 <= score_p2 + 1;
            ball_x <= WIDTH / 2;
            ball_y <= HEIGHT / 2;
            ball_dx <= 1;
            end
    end
end

endmodule