`timescale 1ns / 1ps

module paddle_logic_tb;

    reg clk;
    reg rst;
    reg p1_up, p1_down;
    reg p2_up, p2_down;

    wire [9:0] paddle1_y;
    wire [9:0] paddle2_y;

    paddle_logic uut (
        .clk(clk), 
        .rst(rst), 
        .p1_up(p1_up), 
        .p1_down(p1_down), 
        .p2_up(p2_up), 
        .p2_down(p2_down), 
        .paddle1_y(paddle1_y), 
        .paddle2_y(paddle2_y)
    );

    always #20 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        p1_up = 0; p1_down = 0;
        p2_up = 0; p2_down = 0;

        $display("--- Start Simulation ---");
        #100;
        rst = 0;
        #20;
        
        //Check Initial Position
        if (paddle1_y == 220) $display("[PASS] Reset Position Correct (220)");
        else $display("[FAIL] Reset Position: %d", paddle1_y);

        //Move Paddle 1 UP
        p1_up = 1;
        #100; 
        p1_up = 0;
        $display("Pos after Moving Up: %d", paddle1_y);
        
        // Move Paddle 1 DOWN
        p1_down = 1;
        #200;
        p1_down = 0;
        $display("Pos after Moving Down: %d", paddle1_y);

        //Try to go past 0
        rst = 1; #20; rst = 0;
        p1_up = 1; 
        #5000; 
        if (paddle1_y == 0) $display("[PASS] Top Boundary Check OK (0)");
        else $display("[FAIL] Did not stop at 0. Current: %d", paddle1_y);
        $finish;
    end
endmodule