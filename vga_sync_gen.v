

module vga_sync_gen (
    input clk,
    input rst,  // active high, rst = 1 then reset
    output h_sync,
    output v_sync,
    output [10:0] pixel_x, pixel_y,   // 640 x 480; 0-639 and 0-479
    output video_on 
);

    // resolution
    parameter HD = 640;                     // horizontal display area width in pixels
    parameter HF = 48;                      // horizontal front porch width in pixels 
    parameter HB = 16;                      // horizontal back porch width in pixels
    parameter HR = 96;                      // horizontal retrace width in pixels, sync pulse
    parameter HMAX = HD + HF + HB + HR - 1; // max value of horizontal counter = 799
            
    parameter VD = 480;                     // vertical display area width in pixels
    parameter VF = 10;                      // vertical front porch width in pixels 
    parameter VB = 33;                      // vertical back porch width in pixels
    parameter VR = 2;                       // vertical retrace width in pixels. sync pulse
    parameter VMAX = VD + VF + VB + VR - 1; //max value of horizontal counter = 524

    reg [1:0] r_25MHz;
    wire w_25MHz;

    reg [9:0] h_count_reg, h_count_next;
    reg [9:0] v_count_reg, v_count_next;

    reg h_sync_reg, v_sync_reg;
    reg [9:0] pixel_x_reg, pixel_y_reg;
    reg video_on_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_count_reg <= 0;
            v_count_reg <= 0;
            h_sync_reg <= 1'b1; // inactive (high)
            v_sync_reg <= 1'b1;
            pixel_x_reg <= 0;
            pixel_y_reg <= 0;
            video_on_reg <= 1'b0;
        
        end else begin
            h_count_reg <= h_count_next;
            v_count_reg <= v_count_next;
            h_sync_reg <= (h_count_reg >= (HD + HF) && h_count_reg < (HD + HF + HR)) ? 1'b0 : 1'b1;
            v_sync_reg <= (v_count_reg >= (VD + VF) && v_count_reg < (VD + VF + VR)) ? 1'b0 : 1'b1;    
            pixel_x_reg <= h_count_reg;
            pixel_y_reg <= v_count_reg;
            video_on_reg <= (h_count_reg < HD) && (v_count_reg < VD);
        end
    end 

    always @* begin
        h_count_next = h_count_reg + 1;
        v_count_next = v_count_reg;

        if (h_count_reg == HMAX - 1) begin
            h_count_next = 0;
            if (v_count_reg == VMAX - 1) begin
                v_count_next = 0;
            end else begin
                v_count_next = v_count_reg + 1;
            end
        end
    end

    assign h_sync = h_sync_reg;
    assign v_sync = v_sync_reg;
    assign pixel_x = pixel_x_reg;
    assign pixel_y = pixel_y_reg;
    assign video_on = video_on_reg;

endmodule
