module TOP (
    input wire clk,             // 100MHz 板载时钟
    input wire rstn,            // 重置信号（低有效）
    output wire [3:0] r, g, b,  // VGA RGB 输出
    output wire hs,             // VGA 水平同步
    output wire vs              // VGA 垂直同步
);
    // 时钟分频
    wire [31:0] clk_div;
    CLKDIV clkdiv (.clk(clk), .rst(1'b0), .clk_div(clk_div));

    // VGA 控制
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

    localparam CX = 480 / 2;
    localparam CY = 640 / 2;
    localparam R = 100;
    integer i, j;
    initial begin
        for (i = 0; i < 480; i = i + 1) begin
            for (j = 0; j < 640; j = j + 1) begin
                if ((i - CX) * (i - CX) + (j - CY) * (j - CY) < R * R) begin
                    vram.r[i][j] = 3'b111;
                    vram.g[i][j] = 3'b111;
                    vram.b[i][j] = 2'b11;
                end else begin
                    vram.r[i][j] = 3'b000;
                    vram.g[i][j] = 3'b000;
                    vram.b[i][j] = 2'b11;
                end
            end
        end
    end
endmodule
