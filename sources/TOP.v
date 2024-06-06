module TOP (
    input clk,             // 100MHz clock
    input rstn,            // Reset signal (low active)
    output [3:0] r, g, b,  // VGA RGB Output
    output hs,             // VGA Horizontal Sync
    output vs              // VGA Vertical Sync
);
    localparam WIDTH = 640;
    localparam HEIGHT = 480;

    // Clock Division
    wire [31:0] clk_div;
    CLKDIV clkdiv (.clk(clk), .rst(1'b0), .clk_div(clk_div));

    // VGA Control
    wire [8:0] row_addr; // Y
    wire [9:0] col_addr; // X
    wire [11:0] vgac_in;
    wire rdn;
    VGAC vgac (
        .clk(clk_div[1]),
        .clrn(rstn),
        .din(vgac_in),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .r(r), .g(g), .b(b),
        .hs(hs), .vs(vs), .rdn(rdn)
    );

    // VROM
    wire [18:0] vrom_addr_r = row_addr * WIDTH + col_addr;
    reg [18:0] vrom_addr_w = 19'b0;
    wire [11:0] vrom_out;
    wire [11:0] vrom_in = 12'b0000_1111_1111;
    wire vrom_we = 1'b1;
    assign vgac_in = vrom_out;
    VROM vrom (
        .clka(clk_div[1]),         // Write
        .addra(vrom_addr_w),
        .dina(vrom_in),
        .wea(vrom_we),
        .clkb(clk),                // Read
        .addrb(vrom_addr_r),
        .doutb(vrom_out)
    );

    always @ (posedge clk) vrom_addr_w <= vrom_addr_w + 1;

    // IMAGE
    // IMAGE image (
    //     .clk(clk),
    //     .we(vrom_we),
    //     .addr(vrom_addr_w),
    //     .dout(vrom_in)
    // );
endmodule
