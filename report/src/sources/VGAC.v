module VGAC (
    input clk,                  // 25MHz VGA clock
    input clrn,                 // Reset signal (low active)
    input [11:0] din,           // Color data, rrrr_gggg_bbbb

    output reg [8:0] row_addr,  // Row 480px
    output reg [9:0] col_addr,  // Col 640px
    output reg [3:0] r, g, b,   // VGA RGB444 output
    output reg rdn,             // Read enable (low active)
    output reg hs,              // h_sync
    output reg vs               // v_sync
);
    // hcnt: horizontal counter (0-799)
    reg [9:0] hcnt;
    always @ (posedge clk) begin
        if (!clrn) hcnt <= 0;
        else if (hcnt == 799) hcnt <= 0;
        else hcnt <= hcnt + 1;
    end

    // vcnt: vertical counter (0-524)
    reg [9:0] vcnt;
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) vcnt <= 0;
        else if (hcnt == 799) begin
            if (vcnt == 524) vcnt <= 0;
            else vcnt <= vcnt + 1;
        end
    end

    wire [9:0] row    =  vcnt - 35;      // Row address
    wire [9:0] col    =  hcnt - 143;     // Col address
    wire       h_sync = (hcnt > 95);     //  96 -> 799
    wire       v_sync = (vcnt > 1);      //   2 -> 524
    wire       read   = (hcnt > 142) &&  // 143 -> 782
                        (hcnt < 783) &&  //        640px
                        (vcnt > 34)  &&  //  35 -> 514
                        (vcnt < 515);    //        480 rows

    // vga signals
    always @ (posedge clk) begin
        row_addr <=  row[8:0]; // RAM row address
        col_addr <=  col;      // RAM col address
        rdn      <= ~read;     // Read enable (low active)
        hs       <=  h_sync;   // Horizontal sync
        vs       <=  v_sync;   // Vertical sync
        r        <=  rdn ? 4'h0 : din[11:8];   // 4-bit Red
        g        <=  rdn ? 4'h0 : din[7:4];    // 4-bit Green
        b        <=  rdn ? 4'h0 : din[3:0];    // 4-bit Blue
    end
endmodule
