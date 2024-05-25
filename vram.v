module vram (
    input wire clk,     // 25MHz
    input wire rdn,     // read pixel RAM (active low)
    input wire [8:0] row_addr, col_addr,
    output wire [11:0] d_out
);
    reg [11:0] ram [0:479][0:639]; // 480x640 pixel RAM
    always @ (posedge clk) begin
        if (!rdn) begin
            d_out <= ram[row_addr][col_addr];
        end
    end
endmodule
