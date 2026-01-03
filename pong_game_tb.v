`timescale 1ns / 1ps

module pong_game_tb;

    // 1. Khai báo các tín hiệu kết nối
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

    // 2. Gọi module tổng hợp (UUT - Unit Under Test)
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

    localparam real CLK_PERIOD_NS = 40.0;
    localparam integer SIM_TIME_NS = 10_000_000;

    // 3. Tạo xung nhịp (Clock) ~25MHz (chu kỳ 40ns)
    initial begin
        clk = 0;
        forever #(CLK_PERIOD_NS/2.0) clk = ~clk; 
    end

    // 4. Kịch bản mô phỏng
    initial begin
        // Khởi tạo file dump để xem Waveform trên EPWave
        $dumpfile("pong_game.vcd");
        $dumpvars(0, pong_game_tb);

        // Reset hệ thống 
        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;

        // Cho game chạy một khoảng thời gian đủ dài để thấy bóng di chuyển
        // 10ms mô phỏng (tương đương 10,000,000 ns)
        #(SIM_TIME_NS); 

        $display("Simulation Finished");
        $finish;
    end

endmodule
