module STATIC (
    input clk,
    input [9:0] v_X,
    input [8:0] v_Y,
    output [11:0] dout
);
    wire [11:0] vram_dout;
    assign dout = v_X <= 2 ? 12'h049 : vram_dout; 
    IMAGESHEET imagesheet (
        .clk(clk),
        .addr(v_X + v_Y * 640),
        .dout(vram_dout)
    );
endmodule