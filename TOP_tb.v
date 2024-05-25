`timescale 1ns / 1ps

module top_tb;
    reg clk, rstn;
    wire [3:0] r, g, b;
    wire hs, vs;

    TOP UUT (
        .clk(clk),
        .rstn(rstn),
        .r(r), .g(g), .b(b),
        .hs(hs), .vs(vs)
    );

    integer i, j;
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
        
        rstn = 0; #10; rstn = 1;
        for (i = 0; i < 480; i = i + 1) begin
            for (j = 0; j < 640; j = j + 1) begin
                UUT.vram.r[i][j] = 3'b111;
                UUT.vram.g[i][j] = 3'b111;
                UUT.vram.b[i][j] = 2'b11;
            end
        end
    end
endmodule
