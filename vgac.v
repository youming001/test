module VGAC (
    input wire vga_clk,         // 25MHz
    input wire clrn,            // clrn, active low
    input wire [11:0] d_in,     // bbbb_gggg_rrrr, pixel

    output reg [8:0] row_addr, // pixel ram row address, 480 (512) lines
    output reg [9:0] col_addr, // pixel ram col address, 640 (1024) pixels
    output reg [3:0] r, g, b,  // red, green, blue colors
    output reg rdn,            // read pixel RAM (active low)
    output reg hs,             // horizontal sync
    output reg vs              // vertical sync
);
    // h_count: VGA horizontal counter (0-799)
    reg [9:0] h_count;
    always @ (posedge vga_clk) begin
        if (!clrn) h_count <= 0;
        else if (h_count == 799) h_count <= 0;
        else h_count <= h_count + 1;
    end

    // v_count: VGA vertical counter (0-524)
    reg [9:0] v_count;
    always @ (posedge vga_clk or negedge clrn) begin
        if (!clrn) v_count <= 0;
        else if (h_count == 799) begin
            if (v_count == 524) v_count <= 0;
            else v_count <= v_count + 1;
        end
    end

    // signals, will be latched for outputs
    wire [9:0] row    =  v_count - 35;      // pixel ram row addr 
    wire [9:0] col    =  h_count - 143;     // pixel ram col addr 
    wire       h_sync = (h_count > 95);     //  96 -> 799
    wire       v_sync = (v_count > 1);      //   2 -> 524
    wire       read   = (h_count > 142) &&  // 143 -> 782
                        (h_count < 783) &&  //        640 pixels
                        (v_count > 34)  &&  //  35 -> 514
                        (v_count < 515);    //        480 lines

    // vga signals
    always @ (posedge vga_clk) begin
        row_addr <=  row[8:0]; // pixel ram row address
        col_addr <=  col;      // pixel ram col address
        rdn      <= ~read;     // read pixel (active low)
        hs       <=  h_sync;   // horizontal synchronization
        vs       <=  v_sync;   // vertical synchronization
        r        <=  rdn ? 4'h0 : d_in[3:0];    // 3-bit red
        g        <=  rdn ? 4'h0 : d_in[7:4];    // 3-bit green
        b        <=  rdn ? 4'h0 : d_in[11:8];   // 2-bit blue
    end
endmodule
