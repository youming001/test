module LEDDISP (
    input clk,
    output [7:0] LED,
    output LED_CLK,
    output LED_DT,
    output LED_EN,
    output LED_CLR
);
    wire [15:0] num;
    wire clk_500ms;
    wire clk_125ms;

    reg clkt;
    reg [15:0] count = 1'b0;
    reg [7:0] shift_LED = 8'h01;
    reg switch = 1'b0;      // 0: left  1: right
    reg start = 1'b0;

    assign LED = shift_LED;
    assign num = ~count;

    always @ (negedge clk) begin
        if (clk_125ms && ~clkt) start <= 1;
        else start <= 0;
        clkt <= clk_125ms;
    end

    always @ (posedge clk_500ms) begin
        case (shift_LED)
            8'h01: switch = 1'b0;   // left
            8'h80: switch = 1'b1;   // right
            default: shift_LED = shift_LED;
        endcase
        case (switch)
            1'b0: shift_LED <= shift_LED << 1;
            1'b1: shift_LED <= shift_LED >> 1;
        endcase
    end

    always @ (posedge clk_125ms) begin
        if (count == 16'hFFFF) count <= 0;
        else count <= count + 1;
    end

    clk_500ms clk500ms(.clk(clk), .clk_500ms(clk_500ms));
    clk_125ms clk125ms(.clk(clk), .clk_125ms(clk_125ms));

    LEDDRV leddrv(
        .clk(clk),
        .num(num),
        .start(start),
        .LED_CLK(LED_CLK),
        .LED_DT(LED_DT),
        .LED_EN(LED_EN),
        .LED_CLR(LED_CLR)
    );
endmodule


module clk_500ms(
    input clk,
    output reg clk_500ms
);
    reg [31:0] cnt = 32'b0;

    always @ (posedge clk) begin
        if (cnt < 25_000_000) cnt <= cnt + 1'b1;
        else begin
            cnt <= 0;
            clk_500ms <= ~clk_500ms;
        end
    end
endmodule


module clk_125ms(
    input clk,
    output reg clk_125ms
);
    reg [31:0] cnt = 32'b0;

    always @ (posedge clk) begin
        if (cnt < 6_250_000) cnt <= cnt + 1'b1;
        else begin
            cnt <= 0;
            clk_125ms <= ~clk_125ms;
        end
    end
endmodule


module FD(
    input clk, D,
    output Q, Qn
);
    reg Q_reg = 1'b0;
    always @ (posedge clk) Q_reg <= D;

    assign Q = Q_reg;
    assign Qn = ~Q_reg;
endmodule

module LEDDRV (
    input clk,
    input start,
    input [15:0] num,
    output LED_CLK,
    output LED_DT,
    output LED_EN,
    output LED_CLR
);
    wire [15:0] hex;
    wire finish;
    wire Q, Qn;

    reg s_in;

    assign finish = &hex[14:0];
    assign LED_CLK = ~clk | finish;
    assign LED_DT = hex[15];
    assign LED_CLR = 1'b1;
    assign LED_EN = finish;

    always @ (negedge clk) s_in <= ~start;

    FD f0(.clk(clk), .D(s_in), .Q(Q), .Qn(Qn));
    shift_reg8b s1(.clk(clk), .S_L(start), .s_in(hex[7]), .p_in(num[15:8]), .Q(hex[15:8]));
    shift_reg8b s0(.clk(clk), .S_L(start), .s_in(Q), .p_in(num[7:0]), .Q(hex[7:0]));
endmodule
