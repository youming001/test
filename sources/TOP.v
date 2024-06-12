`include "PARAMS.v"

module TOP (
    input clk,             // 100MHz clock
    input rstn,            // Reset signal (low active)
    input [15:0] SW,       // Switch 
    output [3:0] r, g, b,  // VGA RGB Output
    output hs,             // VGA Horizontal Sync
    output vs              // VGA Vertical Sync
);
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


    // LOGIC
    reg [2:0] move;
    wire [3:0] chunk_type;
    wire [3:0] req_x = (col_addr - 80) / 48;
    wire [3:0] req_y = row_addr / 48;
    LOGIC logic (
        .clk(clk),
        .is_center(col_addr >= 80 && col_addr <= 559),
        .req_x(req_x),
        .req_y(req_y),
        .move(move),
        .chunk_type(chunk_type)
    );


    // RENDER
    wire [5:0] sp_x = (col_addr - 80 + 48 * 2) % 48; // 48 * 2 is to avoid negative value
    wire [5:0] sp_y = row_addr % 48;
    RENDER render (
        .clk(clk),
        .sp_x(sp_x),
        .sp_y(sp_y),
        .chunk_type(chunk_type),
        .dout(vgac_in)
    );


    // SWITCH
    reg [15:0] old_SW = 16'b0;
    always @ (posedge clk) begin
        if ((|SW) && ~(|old_SW)) begin
            if (SW[0]) move <= `RIGHT;
            else if (SW[1]) move <= `LEFT;
            else if (SW[2]) move <= `DOWN;
            else if (SW[3]) move <= `UP;
            else if (SW[15]) move <= `RESET;
        end else move <= `NONE;
        old_SW <= SW;
    end
endmodule
