module top (
    input wire clk,             // 25MHz
    input wire rstn,            // reset
    output wire [3:0] r, g, b,  // blue
    output wire hs,             // horizontal sync
    output wire vs              // vertical sync
);
    wire [8:0] row_addr, col_addr;
    wire rdn;
    wire [11:0] d_in;

    vgac vgac_ (
        .vga_clk(clk),
        .clrn(rstn),
        .d_in(d_in),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .r(r),
        .g(g),
        .b(b),
        .rdn(rdn),
        .hs(hs),
        .vs(vs)
    );

    vram vram_ (
        .clk(clk),
        .rdn(rdn),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .d_out(d_in)
    );

    initial begin
        
    end
endmodule