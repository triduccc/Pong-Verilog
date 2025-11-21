module bot_ai (
    input  wire       clk,       
    input  wire       rst,       
    input  wire [9:0] ball_y,     // Ball Y position
    input  wire [9:0] paddle_y,   // Current paddle Y position (top edge)
    output reg        move_up,    
    output reg        move_down   
);

    parameter PADDLE_HEIGHT = 40; 
    // Bot stay still if the ball is in this range of the paddle center
    parameter DEADZONE = 3; 

    reg [9:0] paddle_center; 

    always @(posedge clk) begin
        if (rst) begin
            // On reset, clear movement commands
            move_up   <= 1'b0;
            move_down <= 1'b0;
        end else begin
            paddle_center = paddle_y + (PADDLE_HEIGHT / 2);
            
            // Ball is above the paddle center
            if (ball_y < (paddle_center - DEADZONE)) begin
                move_up   <= 1'b1; // Command move up
                move_down <= 1'b0;
            end
            
            // Ball is below the paddle center
            else if (ball_y > (paddle_center + DEADZONE)) begin
                move_up   <= 1'b0;
                move_down <= 1'b1; // Command move down
            end
            
            // Ball is within the DEADZONE 
            else begin
                move_up   <= 1'b0; // Stay still
                move_down <= 1'b0; // Stay still
            end
        end
    end

endmodule
