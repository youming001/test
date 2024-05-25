module TOP (
    input wire clk,             // 100MHz clock
    input wire rstn,            // vga reset
    output wire [3:0] r, g, b,  // vga rgb output
    output wire hs,             // horizontal sync
    output wire vs              // vertical sync
);
    wire [31:0] clk_div;
    CLKDIV clkdiv (.clk(clk), .rst(1'b0), .clk_div(clk_div));

    wire [8:0] row_addr;
    wire [9:0] col_addr;
    wire [11:0] d_in;
    VRAM vram (
        .vga_clk(clk_div[1]),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .d_out(d_in)
    );
    VGAC vgac (
        .vga_clk(clk_div[1]),
        .clrn(rstn),
        .d_in(d_in),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .r(r), .g(g), .b(b),
        .hs(hs), .vs(vs), .rdn()
    );

    integer i, j;
    initial begin
        for (i = 0; i < 480; i = i + 1) begin
            for (j = 0; j < 640; j = j + 1) begin
                vram.r[i][j] = 3'b000;
                vram.g[i][j] = 3'b000;
                vram.b[i][j] = 2'b11;
            end
        end
    end
endmodule
