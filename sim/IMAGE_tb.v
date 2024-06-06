`timescale 1ns / 1ps

module IMAGE_tb;
    reg clk;
    wire we;
    wire [18:0] addr;
    wire [7:0] dout;

    wire [11:0] s_addr;
    wire [7:0] s_dout;
    wire [6:0] i, j;

    IMAGE UUT (
        .clk(clk),
        .we(we),
        .addr(addr),
        .dout(dout)
    );

    assign s_addr = UUT.s_addr;
    assign s_dout = UUT.s_dout;
    assign i = UUT.i;
    assign j = UUT.j;

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
endmodule
