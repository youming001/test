module RENDER (
    input clk,
    input [5:0] sp_x, sp_y,
    input [3:0] chunk_type,
    output [11:0] dout
);
    wire [14:0] addr = chunk_type * 48 * 48 + sp_y * 48 + sp_x;

    SPRITESHEET spritesheet (
        .clk(clk),
        .addr(addr),
        .dout(dout)
    );

    // always @ (posedge clk) begin
    //     case (chunk_type)
    //         `PLAYER_UP:     rgb <= 12'hFFF; // white
    //         `PLAYER_DOWN:   rgb <= 12'hCCC;
    //         `PLAYER_LEFT:   rgb <= 12'h666;
    //         `PLAYER_RIGHT:  rgb <= 12'h000; // black
    //         `BOX:           rgb <= 12'hF00; // red
    //         `TARGET:        rgb <= 12'h0F0; // green
    //         `WALL:          rgb <= 12'h00F; // blue
    //         `GROUND:        rgb <= 12'hFF0; // yellow
    //         `SIDE:          rgb <= 12'h222; // gray
    //     endcase
    // end
endmodule