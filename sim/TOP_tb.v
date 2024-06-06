`timescale 1ns / 1ps

module TOP_tb;
    reg clk, rstn;
    wire [3:0] r, g, b;
    wire hs, vs;

    TOP UUT (
        .clk(clk),
        .rstn(rstn),
        .r(r), .g(g), .b(b),
        .hs(hs), .vs(vs)
    );

    wire rdn = UUT.rdn;
    wire [18:0] vrom_addr_w = UUT.vrom_addr_w;
    wire [11:0] vrom_in = UUT.vrom_in;
    wire [8:0] row_addr = UUT.row_addr;
    wire [9:0] col_addr = UUT.col_addr;
    wire [18:0] vrom_addr_r = UUT.vrom_addr_r;
    wire [11:0] vrom_out = UUT.vrom_out;
    wire [11:0] vgac_in = UUT.vgac_in;

    integer fd;
    initial begin
        fd = $fopen("./output.ppm", "w");
        clk = 0; rstn = 0; #10; rstn = 1;
    end
    
    always @ (posedge UUT.clk_div[1]) if (~rdn) $fwrite(fd, "%d %d %d ", r, g, b);
    always @ (posedge vs) $fwrite(fd, "\n\nP3 640 480 16\n");
    always @ (posedge hs) $fwrite(fd, "\n");
    always #1 clk = ~clk;
endmodule
