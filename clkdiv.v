module clkdiv (
    input wire clk,
    input wire rst,
    output reg [31:0] clk_div
);
    initial begin
        clk_div = 0;
    end

    always @ (posedge clk or posedge rst) begin
        if (rst) clk_div <= 0;
        else clk_div <= clk_div + 1'b1;
    end
endmodule
