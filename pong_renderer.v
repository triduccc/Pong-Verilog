module pong_renderer (
    input wire [10:0] pixel_x,   
    input wire [10:0] pixel_y,   
    input wire video_on,        
    input wire [9:0] paddle1_y, 
    input wire [9:0] paddle2_y, 
    input wire [9:0] ball_x,    
    input wire [9:0] ball_y,    
    output reg [11:0] rgb       
);

    //Layout
    parameter PADDLE_W = 10;    
    parameter PADDLE_H = 40;   
    parameter BALL_SIZE = 8;    
    
    // Paddle Pos
    parameter P1_X_L = 30;      
    parameter P1_X_R = 30 + PADDLE_W; 
    parameter P2_X_L = 600;     
    parameter P2_X_R = 600 + PADDLE_W;

    //object hit
    wire paddle1_on, paddle2_on, ball_on;

    // Check if current pixel is inside Paddle 1
    assign paddle1_on = (pixel_x >= P1_X_L && pixel_x < P1_X_R) &&
                        (pixel_y >= paddle1_y && pixel_y < paddle1_y + PADDLE_H);

    // Check if current pixel is inside Paddle 2
    assign paddle2_on = (pixel_x >= P2_X_L && pixel_x < P2_X_R) &&
                        (pixel_y >= paddle2_y && pixel_y < paddle2_y + PADDLE_H);

    // Check if current pixel is inside Ball
    assign ball_on = (pixel_x >= ball_x && pixel_x < ball_x + BALL_SIZE) &&
                     (pixel_y >= ball_y && pixel_y < ball_y + BALL_SIZE);

    //Color
    always @* begin
        if (~video_on) begin
            rgb = 12'h000; 
        end else begin
            if (ball_on)
                rgb = 12'hF00; // Red: 0xF00
            else if (paddle1_on)
                rgb = 12'h0F0; // Green: 0x0F0
            else if (paddle2_on)
                rgb = 12'h00F; // Blue: 0x00F
            else
                rgb = 12'h000; // Black
        end
    end

endmodule
