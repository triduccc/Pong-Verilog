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
    parameter WIDTH = 80;
    parameter HEIGHT = 24;
    parameter SCALE_X = 640 / WIDTH;
    parameter SCALE_Y = 480 / HEIGHT;
    parameter PADDLE_WIDTH = 4;
    parameter BALL_SIZE = 1;
    parameter UPDATE_INTERVAL = 1000;

    reg [31:0] update_counter = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            update_counter <= 0;
        end else begin
            update_counter <= update_counter + 1;
            if (update_counter >= UPDATE_INTERVAL) begin
                update_counter <= 0;
                display();
            end
        end
    end

    task display();
        integer i, j;
        reg [1:0] row [0:WIDTH-1];  // each row is a vector
        begin
            $display("P1 Score: %d P2 Score: %d", score_p1, score_p2);
            $display("");

            //print each row
            for (i = 0; i < HEIGHT; i = i + 1) begin
                // reset each row to 0
                for (j = 0; j < WIDTH; j = j + 1) begin
                    row[j] = 0;
                end

                // check for paddles
                if (i >= (paddle1_y / SCALE_Y) && i < ((paddle1_y + 40) / SCALE_Y)) begin
                    for (j = 0; j < PADDLE_WIDTH; j = j +1) begin
                        row[j] = 1;
                    end
                end

                if (i >= (paddle2_y / SCALE_Y) && i < ((paddle2_y + 40) / SCALE_Y)) begin
                    for (j = 0; j < PADDLE_WIDTH; j = j +1) begin
                        row[WIDTH-1-j] = 1;
                    end
                end

                //check for ball
                if (i == (ball_y / SCALE_Y) && (ball_x / SCALE_X) < WIDTH) begin
                    row[ball_x / SCALE_X] = 2;
                end

                //print on the terminal
                for (j = 0; j < WIDTH; j = j + 1) begin
                    if (row[j] == 2) $write("O");
                    else if (row[j] == 1) $write("|");
                    else $write(".");
                end
                $display("");

            end

            //move cursor up to overwrite
            $write("\033[%dA", HEIGHT + 2);
        end
    endtask
endmodule

// iverilog -o pong_game.vvp pong_game_tb.v pong_game.v ball_logic.v paddle_logic.v bot_ai.v pong_renderer.v vga_sync_gen.v terminal_display.v
