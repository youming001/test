`include "PARAMS.v"

module IMAGE (
    input clk,
    output we,
    output reg [18:0] addr,
    output [11:0] dout
);
    localparam S_WIDTH = 48;
    localparam S_HEIGHT = 48;

    localparam X_OFFSET = `WIDTH / 2;
    localparam Y_OFFSET = `HEIGHT / 2;

    reg [11:0] s_addr = 11'b0;
    wire [11:0] s_dout;

    SPRITE_ROM sprite (.clk(clk), .addr(s_addr), .dout(s_dout));

    reg [6:0] i = 6'b0, j = 6'b0;
    reg [6:0] tmp_1_i, tmp_1_j;
    reg [6:0] tmp_2_i, tmp_2_j;

    assign we = s_dout == 12'hFFF ? 1'b0 : 1'b1; // white = transparent
    assign dout = s_dout;
    
    always @ (posedge clk) begin
        if (i == S_WIDTH - 1) begin
            i <= 6'b0;
            if (j == S_HEIGHT - 1) j <= 6'b0;
            else j <= j + 1;
        end else i <= i + 1;
        s_addr <= i + j * S_WIDTH;
    end

    always @ (posedge clk) begin
        addr <= (tmp_2_i + X_OFFSET) + (tmp_2_j + Y_OFFSET) * `WIDTH;
        tmp_1_i <= i; tmp_2_i <= tmp_1_i; // 2-cycle delay
        tmp_1_j <= j; tmp_2_j <= tmp_1_j;
    end
endmodule
