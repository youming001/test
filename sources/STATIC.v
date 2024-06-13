module STATIC (
    input clk,
    input [9:0] v_X,
    input [8:0] v_Y,
    output [11:0] dout
);
    IMAGESHEET imagesheet (
        .clk(clk),
        .addr(v_X + v_Y * 640),
        .dout(dout)
    );
endmodule