`include "PARAMS.v"

module TOP (
    input clk,             // 100MHz clock
    input rstn,            // Reset signal (low active)
    input ps2_clk,         // PS2 Clock
    input ps2_data,        // PS2 Data
    output [3:0] AN,       // 7-segment Anode
    output [7:0] SEGMENT,  // 7-segment Segment
    output [7:0] LED,      // LED
    output [3:0] r, g, b,  // VGA RGB Output
    output hs,             // VGA Horizontal Sync
    output vs,             // VGA Vertical Sync
    output SEG_CLK,        // 7-segment Clock
    output SEG_CLR,        // 7-segment Clear
    output SEG_DT,         // 7-segment Data
    output SEG_EN,         // 7-segment Enable
    output LED_CLK,        // LED Clock
    output LED_CLR,        // LED Clear
    output LED_DT,         // LED Data
    output LED_EN          // LED Enable
);
    // Clock Division
    wire [31:0] clk_div;
    CLKDIV clkdiv (.clk(clk), .rst(1'b0), .clk_div(clk_div));


    // VGA Control
    wire [9:0] col_addr; // X
    wire [8:0] row_addr; // Y
    wire [11:0] vgac_in;
    wire rdn;
    VGAC vgac (
        .clk(clk_div[1]),
        .clrn(rstn),
        .din(vgac_in),
        .col_addr(col_addr),
        .row_addr(row_addr),
        .r(r), .g(g), .b(b),
        .hs(hs), .vs(vs), .rdn(rdn)
    );


    // LOGIC
    wire [2:0] move;
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


    // STATIC - Static images, e.g. START, GAMEOVER
    wire [11:0] static_out;
    STATIC static (
        .clk(clk_div[1]),
        .v_X(col_addr),
        .v_Y(row_addr),
        .dout(static_out)
    );


    // RENDER
    wire [5:0] sp_x = (col_addr - 80 + 48 * 2) % 48; // 48 * 2 is to avoid negative value
    wire [5:0] sp_y = row_addr % 48;
    wire [11:0] render_out;
    RENDER render (
        .clk(clk_div[1]),
        .sp_x(sp_x),
        .sp_y(sp_y),
        .chunk_type(chunk_type),
        .dout(render_out)
    );
    assign vgac_in = logic.state == `START ? static_out : render_out;


    // Level Display
    LVDISP lvdisp (
        .scan(clk_div[18:17]),
        .din({1'b0, logic.level}),
        .SEGMENT(SEGMENT),
        .AN(AN)
    );


    // Score Display
    SCDISP scdisp (
        .clk(clk),
        .din({1'b0, logic.score}),
        .SEG_CLK(SEG_CLK),
        .SEG_CLR(SEG_CLR),
        .SEG_DT(SEG_DT),
        .SEG_EN(SEG_EN)
    );


    // LED Display
    LEDDISP leddisp (
        .clk(clk),
        .LED(LED),
        .LED_CLK(LED_CLK),
        .LED_DT(LED_DT),
        .LED_EN(LED_EN),
        .LED_CLR(LED_CLR)
    );


    // CONTROL
    KEYBOARD keyboard (
        .clk(clk),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .move(move)
    );
endmodule
