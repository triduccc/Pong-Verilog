`timescale 1ns / 1ps

module vga_sync_gen_tb;

    // ==========================================
    // 1. Signal Declarations
    // ==========================================
    reg clk;
    reg rst;
    wire h_sync;
    wire v_sync;
    wire [10:0] pixel_x;
    wire [10:0] pixel_y;
    wire video_on;

    // ==========================================
    // 2. Instantiate the Unit Under Test (UUT)
    // ==========================================
    vga_sync_gen uut (
        .clk(clk), 
        .rst(rst), 
        .h_sync(h_sync), 
        .v_sync(v_sync), 
        .pixel_x(pixel_x), 
        .pixel_y(pixel_y), 
        .video_on(video_on)
    );

    // ==========================================
    // 3. Clock Generation
    // ==========================================
    // Standard VGA 640x480 @ 60Hz uses ~25.175 MHz pixel clock.
    // We approximate this with 25 MHz -> Period = 40ns (20ns high, 20ns low)
    always #20 clk = ~clk; 

    // ==========================================
    // 4. Test Logic
    // ==========================================
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1; // Active High Reset as per requirements

        // Wait 100 ns for global reset to finish
        $display("--- Simulation Start ---");
        #100;
        
        // De-assert Reset to start operation
        rst = 0; 
        $display("--- Reset De-asserted ---");

        // Run simulation for specific duration
        // 1 Line = 800 clocks = 32,000 ns
        // 1 Frame = 525 lines = ~16.8 ms
        // We will run long enough to see a few lines complete.
        #200000; // Run for 200us
        
        $display("--- Simulation End ---");
        $finish;
    end

    // ==========================================
    // 5. Output Monitoring (Terminal Display)
    // ==========================================
    
    // Monitor H-Sync (New Line)
    // Triggers when h_sync goes LOW (Active Low logic)
    always @(negedge h_sync) begin
        $display("[Time %t] H-SYNC Triggered (Start of Retrace). Current Line (Y): %d", $time, pixel_y);
    end

    // Monitor V-Sync (New Frame)
    // Triggers when v_sync goes LOW
    always @(negedge v_sync) begin
        $display("[Time %t] *** V-SYNC Triggered (New Frame) ***", $time);
    end

    // Optional: Monitor coordinate rollover
    always @(posedge clk) begin
        if (pixel_x == 0 && pixel_y == 0 && !rst) begin
            $display("[Time %t] Pixel Counter Reset to (0,0) - Top Left of Screen", $time);
        end
    end

endmodule