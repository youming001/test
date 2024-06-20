`include "PARAMS.v"

module shift_reg8b(
    input clk, S_L, s_in,
    input [7:0] p_in,
    output reg [7:0] Q
);
    always @ (posedge clk) begin
        if (S_L) Q <= p_in;
        else Q <= {Q[6:0], s_in};
    end
endmodule


module SR_Latch (
    input S,
    input R,
    output Q,
    output NQ
);
    reg tmp = 1'b0;

    always @ (*) begin
        if (!S && R) tmp <= 1'b0;
        else if (S && !R) tmp <= 1'b1;
    end

    assign Q = tmp;
    assign NQ = ~tmp;
endmodule


module SEGDRV (
    input clk,
    input [63:0] num,
    input start,
    output SEG_CLK,
    output SEG_CLR,
    output SEG_DT,
    output SEG_EN
);
    wire [63:0] Q;
    wire S_L, finish;
    reg s_in;
    SR_Latch sr(.S(start & finish), .R(~finish), .Q(S_L), .NQ());
    always @ (posedge clk) s_in <= ~S_L;

    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : reggen
            shift_reg8b sr(
                .clk(clk),
                .S_L(S_L),
                .p_in(num[i*8+7:i*8]),
                .Q(Q[i*8+7:i*8]),
                .s_in(i == 0 ? s_in : Q[i*8-1])
            );
        end
    endgenerate

    assign finish = &Q[62:0];
    assign SEG_DT = Q[63];
    assign SEG_CLK = ~clk | finish;
    assign SEG_CLR = 1'b1;
    assign SEG_EN = finish;
endmodule


module SCDISP (
    input clk,
    input [3:0] din,
    output SEG_CLK,
    output SEG_CLR,
    output SEG_DT,
    output SEG_EN
);
    function [7:0] num2seg (input [3:0] num);
        case (num)
            4'b0000: num2seg = 8'b11000000;
            4'b0001: num2seg = 8'b11111001;
            4'b0010: num2seg = 8'b10100100;
            4'b0011: num2seg = 8'b10110000;
            4'b0100: num2seg = 8'b10011001;
            4'b0101: num2seg = 8'b10010010;
            4'b0110: num2seg = 8'b10000010;
            4'b0111: num2seg = 8'b11111000;
            4'b1000: num2seg = 8'b10000000;
            4'b1001: num2seg = 8'b10010000;
            default: num2seg = 8'b11000000;
        endcase
    endfunction

    wire [63:0] data;
    assign data = {
        8'b10010010, // S
        8'b10100111, // c
        8'b10100011, // o
        8'b10101111, // r
        8'b10000110, // E
        8'b10111111, // -
        8'b11000000, // 0
        num2seg(din) // Score
    };

    reg start, clk_old;
    wire [31:0] clk_div;
    CLKDIV clkdiv (.clk(clk), .rst(1'b0), .clk_div(clk_div));

    always @ (posedge clk) begin
        if (clk_div[16] != clk_old) start <= 1'b1;
        else start <= 1'b0;
        clk_old <= clk_div[16];
    end

    SEGDRV segdrv (
        .clk(clk),
        .num(data),
        .start(start),
        .SEG_CLK(SEG_CLK),
        .SEG_CLR(SEG_CLR),
        .SEG_DT(SEG_DT),
        .SEG_EN(SEG_EN)
    );
endmodule