module LVDISP (
    input [1:0] scan,
    input [3:0] din,
    output [3:0] AN,
    output reg [7:0] SEGMENT
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

    assign AN = {scan != 2'b11, scan != 2'b10, scan != 2'b01, scan != 2'b00};
    always @ (*) begin
        case (scan)
            2'b00: SEGMENT <= num2seg(din); // Level
            2'b01: SEGMENT <= 8'b11000000;  // 0
            2'b10: SEGMENT <= 8'b10111111;  // -
            2'b11: SEGMENT <= 8'b11000111;  // L
        endcase
    end
endmodule
