`timescale 1ns / 1ps

module TOP_tb;
    reg clk, rstn;
    reg [15:0] SW;
    wire [3:0] r, g, b;
    wire hs, vs;

    TOP UUT (
        .clk(clk),
        .rstn(rstn),
        .SW(SW),
        .r(r), .g(g), .b(b),
        .hs(hs), .vs(vs)
    );

    wire rdn = UUT.rdn;
    wire [8:0] row_addr = UUT.row_addr;
    wire [9:0] col_addr = UUT.col_addr;
    wire [11:0] vgac_in = UUT.vgac_in;
    wire [2:0] move = UUT.move;
    wire [1:0] state = UUT.logic.state;
    wire ready = UUT.logic.ready;
    wire move_logic = UUT.logic.move;
    wire [2:0] p_x = UUT.logic.p_x;
    wire [2:0] p_y = UUT.logic.p_y;
    wire [3:0] current_map_x_y = UUT.logic.cur_map[p_x][p_y];
    wire [2:0] dest_x = UUT.logic.dest_x;
    wire [2:0] dest_y = UUT.logic.dest_y;

    initial begin
        clk = 0; SW = 16'b0; #10;
        SW[0] = 1; #10; SW[0] = 0;
        rstn = 0; #10; rstn = 1;
    end

    integer fd, frame_idx = 0;
    reg [8*20:1] filename;
    always @ (posedge vs) begin
        if (fd) $fclose(fd);
        $sformat(filename, "./frame_%0d.ppm", frame_idx);
        fd = $fopen(filename, "w");
        $fwrite(fd, "P3 640 480 16\n");
        frame_idx = frame_idx + 1;
    end
    always @ (posedge UUT.clk_div[1]) if (~rdn) $fwrite(fd, "%d %d %d ", r, g, b);
    always @ (posedge rdn) if (fd) $fwrite(fd, "\n");
    always #1 clk = ~clk;
endmodule
