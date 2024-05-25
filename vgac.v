module VGAC (
    input wire vga_clk,         // 25MHz VGA 时钟
    input wire clrn,            // 重置信号（低有效）
    input wire [11:0] d_in,     // 颜色数据，格式为 bbbb_gggg_rrrr

    output reg [8:0] row_addr,  // 行 480 像素
    output reg [9:0] col_addr,  // 列 640 像素
    output reg [3:0] r, g, b,   // VGA RGB444 输出
    output reg rdn,             // 读取像素（低有效）
    output reg hs,              // h_sync
    output reg vs               // v_sync
);
    // h_count: VGA 水平计数器 (0-799)
    reg [9:0] h_count;
    always @ (posedge vga_clk) begin
        if (!clrn) h_count <= 0;
        else if (h_count == 799) h_count <= 0;
        else h_count <= h_count + 1;
    end

    // v_count: VGA 垂直计数器 (0-524)
    reg [9:0] v_count;
    always @ (posedge vga_clk or negedge clrn) begin
        if (!clrn) v_count <= 0;
        else if (h_count == 799) begin
            if (v_count == 524) v_count <= 0;
            else v_count <= v_count + 1;
        end
    end

    wire [9:0] row    =  v_count - 35;      // 行地址
    wire [9:0] col    =  h_count - 143;     // 列地址
    wire       h_sync = (h_count > 95);     //  96 -> 799
    wire       v_sync = (v_count > 1);      //   2 -> 524
    wire       read   = (h_count > 142) &&  // 143 -> 782
                        (h_count < 783) &&  //        640 像素
                        (v_count > 34)  &&  //  35 -> 514
                        (v_count < 515);    //        480 行

    // vga signals
    always @ (posedge vga_clk) begin
        row_addr <=  row[8:0]; // RAM 行地址
        col_addr <=  col;      // RAM 列地址
        rdn      <= ~read;     // 读取像素（低有效）
        hs       <=  h_sync;   // 水平同步
        vs       <=  v_sync;   // 垂直同步
        r        <=  rdn ? 4'h0 : d_in[3:0];   // 3-bit 红
        g        <=  rdn ? 4'h0 : d_in[7:4];   // 3-bit 绿
        b        <=  rdn ? 4'h0 : d_in[11:8];  // 2-bit 蓝
    end
endmodule
