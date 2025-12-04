module bot_ai(
    input wire clk,
    input wire rst,
    input wire [9:0] paddle_y,
    input wire [9:0] ball_y,
    output reg move_up,
    output reg move_down
);

    parameter PADDLE_HEIGHT = 40;
    parameter DEADZONE = 3; // avoid the paddle moving up and down continuously

    reg [9:0] paddle_center;
    
    always @(posedge clk) begin
        if (rst) begin
            move_up <= 1'b0;
            move_down <= 1'b0;
        end else begin
            paddle_center = paddle_y + (PADDLE_HEIGHT / 2);

            // Ball is above the paddle center
            if (ball_y < (paddle_center - DEADZONE)) begin
                move_up <= 1'b1;
                move_down <= 1'b0;
            end

            // Ball is below the paddle center
            else if (ball_y > (paddle_center + DEADZONE)) begin
                move_up <= 1'b0;
                move_down <= 1'b1;
            end

            // Ball is in the dead zone 
            else begin
                move_up <= 1'b0;
                move_down <= 1'b0;
            end
        end
    end

endmodule


