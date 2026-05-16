`timescale 1ns / 1ps

module pong_renderer_tb;

    // Inputs
    reg [9:0] pixel_x, pixel_y;
    reg video_on;
    reg [9:0] paddle1_y, paddle2_y;
    reg [9:0] ball_x, ball_y;

    // Outputs
    wire [11:0] rgb;

    // Instantiate UUT
    pong_renderer uut (
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .video_on(video_on),
        .paddle1_y(paddle1_y), .paddle2_y(paddle2_y),
        .ball_x(ball_x), .ball_y(ball_y),
        .rgb(rgb)
    );

    initial begin
        $display("--- Start Renderer Test ---");
        
        // Setup Objects
        // Paddle 1 at Y=200, Paddle 2 at Y=300, Ball at (320, 240)
        paddle1_y = 200; 
        paddle2_y = 300;
        ball_x = 320; 
        ball_y = 240;
        video_on = 1;

        // Test 1: Check Background (Empty Space)
        pixel_x = 100; pixel_y = 100;
        #10;
        if (rgb == 12'h000) $display("[PASS] Background is Black");
        else $display("[FAIL] Background Error: %h", rgb);

        // Test 2: Check Ball (at 320, 240)
        pixel_x = 322; pixel_y = 242; // Inside the ball
        #10;
        if (rgb == 12'hF00) $display("[PASS] Ball is Red");
        else $display("[FAIL] Ball Error: %h", rgb);

        // Test 3: Check Paddle 1 (X range 30-40, Y range 200-240)
        pixel_x = 35; pixel_y = 210;
        #10;
        if (rgb == 12'h0F0) $display("[PASS] Paddle 1 is Green");
        else $display("[FAIL] Paddle 1 Error: %h", rgb);

        // Test 4: Check Video Off (Should be black even if inside ball)
        video_on = 0;
        pixel_x = 322; pixel_y = 242; // Inside ball
        #10;
        if (rgb == 12'h000) $display("[PASS] Video Off forces Black");
        else $display("[FAIL] Video Off Error: %h", rgb);

        $display("--- Test Finished ---");
        $finish;
    end

endmodule