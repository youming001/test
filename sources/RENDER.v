module RENDER (
    input clk,
    input [5:0] sp_x, sp_y,
    input [3:0] chunk_type,
    output [11:0] dout
);
    wire [14:0] addr = chunk_type * 48 * 48 + sp_y * 48 + sp_x;

    SPRITESHEET spritesheet (
        .clk(clk),
        .addr(addr),
        .dout(dout)
    );
endmodule