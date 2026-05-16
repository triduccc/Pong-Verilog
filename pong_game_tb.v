`timescale 1ns / 1ps

module pong_game_tb;
    reg clk;
    reg rst;
    wire h_sync;
    wire v_sync;
    wire [11:0] rgb;
    // for display
    wire [9:0] ball_x;
    wire [9:0] ball_y;
    wire [9:0] paddle1_y;
    wire [9:0] paddle2_y;
    wire [3:0] score_p1;
    wire [3:0] score_p2;

    pong_game uut (
        .clk(clk),
        .rst(rst),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .rgb(rgb),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .paddle1_y(paddle1_y),
        .paddle2_y(paddle2_y),
        .score_p1(score_p1),
        .score_p2(score_p2)
    );

    terminal_display display_inst (
        .clk(clk),
        .rst(rst),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .paddle1_y(paddle1_y),
        .paddle2_y(paddle2_y),
        .score_p1(score_p1),
        .score_p2(score_p2)
    );

    localparam real CLK_PERIOD_NS = 1_000_000_000;

    initial begin
        clk = 0;
        forever #(CLK_PERIOD_NS/2.0) clk = ~clk; 
    end

    initial begin
        $dumpfile("pong_game.vcd");
        $dumpvars(0, pong_game_tb);

        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;


    end

endmodule
