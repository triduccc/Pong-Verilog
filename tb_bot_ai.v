`timescale 1ns / 1ps

module tb_bot_ai;

    // 1. Declare signals to connect to the Bot AI module
    // Module inputs are declared as regs (so the testbench can drive them)
    reg clk;
    reg rst;
    reg [9:0] ball_y;
    reg [9:0] paddle_y;

    // Module outputs are declared as wires (so the testbench can observe them)
    wire move_up;
    wire move_down;

    // 2. Instantiate the Bot AI module for testing
    bot_ai uut (
        .clk(clk),
        .rst(rst),
        .ball_y(ball_y),
        .paddle_y(paddle_y),
        .move_up(move_up),
        .move_down(move_down)
    );

    // 3. Clock generator
    // Create clk with a 20ns period (50MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end

    // 4. Test scenario
    initial begin
        // --- Phase 1: Initialization ---
        $display("=== START TESTING BOT AI ===");
        rst = 1;        // Hold reset
        ball_y = 0;
        paddle_y = 0;
        #40;            // Wait 40ns
        rst = 0;        // Release reset
        $display("Reset done.");

        // --- Phase 2: Test Ball ABOVE paddle (Bot should move UP) ---
        // Assume paddle at 300, ball at 200 (smaller Y is above)
        paddle_y = 300; 
        ball_y = 200;   
        #40; // Wait for logic to settle
        
        // Check result
        if (move_up == 1 && move_down == 0) 
            $display("[PASS] Case 1: Ball Above -> Bot Moving UP");
        else 
            $display("[FAIL] Case 1: Ball Above -> Expected UP, got Up=%b Down=%b", move_up, move_down);


        // --- Phase 3: Test Ball BELOW paddle (Bot should move DOWN) ---
        // Paddle remains at 300, ball at 400 (larger Y is below)
        ball_y = 400;
        #40;

        if (move_up == 0 && move_down == 1) 
            $display("[PASS] Case 2: Ball Below -> Bot Moving DOWN");
        else 
            $display("[FAIL] Case 2: Ball Below -> Expected DOWN, got Up=%b Down=%b", move_up, move_down);


        // --- Phase 4: Test Deadzone ---
        // Paddle at 300. Paddle center = 300 + (40/2) = 320.
        // Ball at 322 (very close to center). Bot should stay still.
        ball_y = 322; 
        #40;

        if (move_up == 0 && move_down == 0) 
            $display("[PASS] Case 3: Deadzone -> Bot Standing STILL");
        else 
            $display("[FAIL] Case 3: Deadzone -> Expected STILL, got Up=%b Down=%b", move_up, move_down);

        // End test
        $display("=== TEST FINISHED ===");
        $stop;
    end

endmodule
