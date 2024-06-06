module IMAGE (
    input clk,
    output we,
    output reg [18:0] addr,
    output [7:0] dout
);
    localparam WIDTH = 640;
    localparam HEIGHT = 480;

    localparam S_WIDTH = 48;
    localparam S_HEIGHT = 48;

    localparam X_OFFSET = WIDTH / 2;
    localparam Y_OFFSET = HEIGHT / 2;

    reg [11:0] s_addr = 11'b0;
    wire [7:0] s_dout;

    SPRITE_ROM sprite (
        .clk(clk),
        .addr(s_addr),
        .dout(s_dout)
    );

    reg [6:0] i = 6'b0, j = 6'b0;

    assign we = 1'b1;
    assign dout = s_dout;

    always @ (posedge clk) begin
        i = i + 1;

        if (i == S_WIDTH) begin
            i = 6'b0;
            j = j + 1;
        end

        if (j == S_HEIGHT) begin
            j = 6'b0;
        end

        s_addr = i + j * S_WIDTH;
        addr = (i + X_OFFSET) + (j + Y_OFFSET) * WIDTH;
    end
endmodule
