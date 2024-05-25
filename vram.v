module VRAM (
    input wire vga_clk,
    input wire [8:0] row_addr,
    input wire [9:0] col_addr,
    output reg [11:0] d_out
);
    // 采用 RGB332 格式
    reg [2:0] r [0:479][0:639];
    reg [2:0] g [0:479][0:639];
    reg [1:0] b [0:479][0:639];
    always @ (posedge vga_clk) begin
        d_out[11:8] <= b[row_addr][col_addr];
        d_out[7:4]  <= g[row_addr][col_addr];
        d_out[3:0]  <= r[row_addr][col_addr];
    end
endmodule
