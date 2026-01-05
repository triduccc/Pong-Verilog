module bot_ai(
    input wire clk,
    input wire rst,
    input wire [9:0] paddle1_y,
    input wire [9:0] paddle2_y,
    input wire [9:0] ball_y,
    output reg move_up1,
    output reg move_down1,
    output reg move_up2,
    output reg move_down2
);

    parameter PADDLE_HEIGHT = 5;
    parameter HEIGHT = 24;
    parameter DEADZONE = 0;

    reg [9:0] left_paddle_y;
    reg [9:0] right_paddle_y;
    reg [9:0] ball_ry;
    
    always @(posedge clk) begin
        if (rst) begin
            move_up1 <= 1'b0;
            move_down1 <= 1'b0;
            move_up2 <= 1'b0;
            move_down2 <= 1'b0;
        end else begin
            left_paddle_y = paddle1_y;
            right_paddle_y = paddle2_y;
            ball_ry = ball_y;

            // Left AI: slow and imperfect
            if (ball_ry > (left_paddle_y + (PADDLE_HEIGHT/2) + 1)) begin
                left_paddle_y = left_paddle_y + 1;
                move_down1 <= 1'b1;
                move_up1 <= 1'b0;
            end
            else if (ball_ry < (left_paddle_y + (PADDLE_HEIGHT/2) - 1)) begin
                left_paddle_y = left_paddle_y - 1;
                move_up1 <= 1'b1;
                move_down1 <= 1'b0;
            end
            else begin
                move_up1 <= 1'b0;
                move_down1 <= 1'b0;
            end
            // Right AI: almost perfect (tracks ball center)
            if ((right_paddle_y + (PADDLE_HEIGHT/2)) < ball_ry) begin
                right_paddle_y = right_paddle_y + 2;
                move_down2 <= 1'b1;
                move_up2 <= 1'b0;
            end
            else if ((right_paddle_y + (PADDLE_HEIGHT/2)) > ball_ry) begin
                right_paddle_y = right_paddle_y - 2;
                move_up2 <= 1'b1;
                move_down2 <= 1'b0;
            end
            else begin
                move_up1 <= 1'b0;
                move_down1 <= 1'b0;
            end

        end
    end

endmodule


