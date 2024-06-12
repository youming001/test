module RENDER (
    input clk,
    // input [3:0]
    input [3:0] chunk_type,
    output [11:0] dout
);
    reg [11:0] rgb;
    assign dout = rgb;
    always @ (posedge clk) begin
        case (chunk_type)
            `PLAYER_UP:     rgb <= 12'hFFF; // white
            `PLAYER_DOWN:   rgb <= 12'hCCC;
            `PLAYER_LEFT:   rgb <= 12'h666;
            `PLAYER_RIGHT:  rgb <= 12'h000; // black
            `BOX:           rgb <= 12'hF00; // red
            `TARGET:        rgb <= 12'h0F0; // green
            `WALL:          rgb <= 12'h00F; // blue
            `GROUND:        rgb <= 12'hFF0; // yellow
            `SIDE:          rgb <= 12'h222; // gray
        endcase
    end
endmodule