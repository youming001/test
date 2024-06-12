`timescale 1ns / 1ps

module VROM_tb;
    reg clk;
    wire [31:0] clk_div;
    reg [18:0] vrom_addr_r = 100 + 100 * 640;
    wire [7:0] vrom_out;

    CLKDIV clkdiv (.clk(clk), .rst(1'b0), .clk_div(clk_div));
    VROM vrom (
        .clka(clk_div[1]),         // Write
        .addra(18'b0),
        .dina(12'b0),
        .wea(1'b0),
        .clkb(clk),                // Read
        .addrb(vrom_addr_r),
        .doutb(vrom_out)
    );

    initial begin
        clk = 0;
        #10;
        forever begin
            vrom_addr_r <= vrom_addr_r + 1;
            #10;
        end
    end

    always #1 clk = ~clk;
endmodule
