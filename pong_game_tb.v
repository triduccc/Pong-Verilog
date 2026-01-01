`timescale 1ns / 1ps

module pong_game_tb;

    initial begin
        $dumpfile("pong_waveform.vcd");
        $dumpvars(0, pong_game_tb);

        clk = 0;
        rst = 1;
    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire h_sync;
    wire v_sync;
    wire [11:0] rgb;

    top_level uut (
        .clk(clk), 
        .rst(rst), 
        .h_sync(h_sync), 
        .v_sync(v_sync), 
        .rgb(rgb)
    );

    always #20 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        $display("--- Starting Full System Simulation ---");
        
        #100;
        rst = 0;
        $display("Reset Released.");

        #65000;
        
        $display("--- Simulation Completed ---");
        $finish;
    end
    
endmodule