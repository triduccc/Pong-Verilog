module paddle_logic (
    input wire clk,
    input wire rst,
    input wire p1_up,
    input wire p1_down,
    input wire p2_up,
    input wire p2_down,
    output reg [9:0] paddle1_y,
    output reg [9:0] paddle2_y
);

    // Parameters
    parameter Y_MAX = 479;          
    parameter PADDLE_HEIGHT = 40;   
    parameter PADDLE_VELOCITY = 10;  

    // Center
    localparam CENTER_POS = 220;

    //Paddle 1
    always @(posedge clk) begin
        if (rst) begin
            paddle1_y <= CENTER_POS;
        end else begin
            //Moveing up
            if (p1_up && !p1_down) begin
                if (paddle1_y >= PADDLE_VELOCITY)
                    paddle1_y <= paddle1_y - PADDLE_VELOCITY;
                else
                    paddle1_y <= 0; // Clamp to top
            end
            //Moving down
            else if (p1_down && !p1_up) begin
                if (paddle1_y < (Y_MAX - PADDLE_HEIGHT - PADDLE_VELOCITY))
                    paddle1_y <= paddle1_y + PADDLE_VELOCITY;
                else
                    paddle1_y <= Y_MAX - PADDLE_HEIGHT; 
            end
        end
    end

    //Paddle 2
    always @(posedge clk) begin
        if (rst) begin
            paddle2_y <= CENTER_POS;
        end else begin
            if (p2_up && !p2_down) begin
                if (paddle2_y >= PADDLE_VELOCITY)
                    paddle2_y <= paddle2_y - PADDLE_VELOCITY;
                else
                    paddle2_y <= 0;
            end
            else if (p2_down && !p2_up) begin
                if (paddle2_y < (Y_MAX - PADDLE_HEIGHT - PADDLE_VELOCITY))
                    paddle2_y <= paddle2_y + PADDLE_VELOCITY;
                else
                    paddle2_y <= Y_MAX - PADDLE_HEIGHT;
            end
        end
    end

endmodule
