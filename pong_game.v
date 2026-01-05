module pong_game (
    input wire clk,       // System Clock 
    input wire rst,       // Active High Reset
    output wire h_sync,   // VGA Horizontal Sync
    output wire v_sync,   // VGA Vertical Sync
    output wire [11:0] rgb, // VGA Color Output (4 bits R, G, B)

    // for display
    output wire [9:0] ball_x,
    output wire [9:0] ball_y,
    output wire [9:0] paddle1_y,
    output wire [9:0] paddle2_y,
    output wire [3:0] score_p1,
    output wire [3:0] score_p2
);

    wire [10:0] w_pixel_x;
    wire [10:0] w_pixel_y;
    wire w_video_on;

    // Game Object Positions
    wire [9:0] w_paddle1_y; 
    wire [9:0] w_paddle2_y; 
    wire [9:0] w_ball_x;
    wire [9:0] w_ball_y;
    
    // Scores 
    wire [3:0] w_score_p1;
    wire [3:0] w_score_p2;

    // Bot Control Signals
    wire w_p1_up, w_p1_down;
    wire w_p2_up, w_p2_down;

    assign ball_x = w_ball_x;
    assign ball_y = w_ball_y;
    assign paddle1_y = w_paddle1_y;
    assign paddle2_y = w_paddle2_y;
    assign score_p1 = w_score_p1;
    assign score_p2 = w_score_p2;

    vga_sync_gen vga_inst (
        .clk(clk),
        .rst(rst),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .pixel_x(w_pixel_x),
        .pixel_y(w_pixel_y),
        .video_on(w_video_on)
    );

    //The Physics Engine
    ball_logic ball_inst (
        .clk(clk),
        .rst(rst),
        .paddle1_y(w_paddle1_y),
        .paddle2_y(w_paddle2_y),
        .ball_x(w_ball_x),
        .ball_y(w_ball_y),
        .score_p1(w_score_p1),
        .score_p2(w_score_p2)
    );

    //The Paddles
    paddle_logic paddle_inst (
        .clk(clk),
        .rst(rst),
        .p1_up(w_p1_up),     
        .p1_down(w_p1_down), 
        .p2_up(w_p2_up),     
        .p2_down(w_p2_down), 
        .paddle1_y(w_paddle1_y),
        .paddle2_y(w_paddle2_y)
    );

    // Bot 1 
    bot_ai bot1 (
        .clk(clk),
        .rst(rst),
        .paddle_y(w_paddle1_y), // Watch own paddle
        .ball_y(w_ball_y),      // Watch ball
        .move_up(w_p1_up),      // Output command
        .move_down(w_p1_down)   // Output command
    );

    // Bot 2 
    bot_ai bot2 (
        .clk(clk),
        .rst(rst),
        .paddle_y(w_paddle2_y), // Watch own paddle
        .ball_y(w_ball_y),      // Watch ball
        .move_up(w_p2_up),      // Output command
        .move_down(w_p2_down)   // Output command
    );

    //Graphics Renderer
    pong_renderer renderer_inst (
        .pixel_x(w_pixel_x),
        .pixel_y(w_pixel_y),
        .video_on(w_video_on),
        .paddle1_y(w_paddle1_y),
        .paddle2_y(w_paddle2_y),
        .ball_x(w_ball_x),
        .ball_y(w_ball_y),
        .rgb(rgb)
    );

endmodule
