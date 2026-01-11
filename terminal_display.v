`timescale 1ns / 1ps

module terminal_display (
    input clk,
    input rst,
    input [9:0] ball_x,
    input [9:0] ball_y,
    input [9:0] paddle1_y,
    input [9:0] paddle2_y,
    input [3:0] score_p1,
    input [3:0] score_p2
);

    //parameters, we reduce the screen to just 80x24
    parameter PADDLE_HEIGHT = 5;
    parameter WIDTH = 80;
    parameter HEIGHT = 24;
    parameter UPDATE_INTERVAL = 1_000;
    localparam PADDLE_CHAR = "#";
    localparam EMPTY = " ";
    localparam BALL_CHAR = "o";
    integer frame = 0;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            frame = 0;
        end else begin
            render();
            frame = frame + 1;
        end
    end

    task render;
        integer r, c; // row and col
        begin
            $write("\033[2J\033[H");  // Clear screen & move cursor home 

            // Top border
            $write("+");
            for (c = 0; c < WIDTH-2; c = c + 1) $write("-");
            $display("+  Score: %0d - %0d", score_p1, score_p2);

            // Game field, left = 1, right = 2
            for (r = 1; r < HEIGHT-1; r = r + 1) begin
                $write("|");
                for (c = 1; c < WIDTH-1; c = c + 1) begin
                    if (c == 1 && r >= paddle1_y && r < (paddle1_y + PADDLE_HEIGHT))
                        $write("%s", PADDLE_CHAR);
                    else if (c == WIDTH-2 && r >= paddle2_y && r < (paddle2_y + PADDLE_HEIGHT))
                        $write("%s", PADDLE_CHAR);
                    else if (c == (ball_x) && r == (ball_y))
                        $write("%s", BALL_CHAR);
                    else
                        $write("%s", EMPTY);
                end
                $display("|");
            end

            // Bottom border
            $write("+");
            for (c = 0; c < WIDTH-2; c = c + 1) $write("-");
            $display("+");

            $display("Frame: %0d | Watching two AIs play Pong forever...", frame);
        end
    endtask
endmodule

//iverilog -o pong_game.vvp pong_game_tb.v pong_game.v ball_logic.v paddle_logic.v bot_ai.v pong_renderer.v vga_sync_gen.v terminal_display.v
