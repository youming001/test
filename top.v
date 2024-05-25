`timescale 1ns / 1ps

module TOP (
    input wire clk,             // 100MHz
    input wire rstn,            // reset
    output wire [3:0] r, g, b,  // rgb
    output wire hs,             // horizontal sync
    output wire vs              // vertical sync
);
    wire [8:0] row_addr;
    wire [9:0] col_addr;
    wire [11:0] d_in;
    wire rdn;
    wire [31:0] clk_div;

    CLKDIV clkdiv (.clk(clk), .rst(1'b0), .clk_div(clk_div));

    VGAC vgac (
        .vga_clk(clk_div[2]),
        .clrn(rstn),
        .d_in(d_in),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .r(r), .g(g), .b(b),
        .rdn(rdn), .hs(hs), .vs(vs)
    );

    VRAM vram (
        .clk(clk_div[2]),
        .rdn(rdn),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .d_out(d_in)
    );

    initial begin
        integer i = 0, j = 0;
        for (i = 0; i < 480; i = i + 1) begin
            for (j = 0; j < 640; j = j + 1) begin
                vram.ram[i][j] = 12'h1111_1111_1111;
            end
        end
    end
endmodule
