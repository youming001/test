`include "PARAMS.v"


// Game logic module
module LOGIC (
    input clk,                  // 100MHz clock
    input is_center,            // Is chunk at the center
    input [3:0] req_x, req_y,   // Request (x, y) chunk
    input [2:0] move,           // Operation to be performed
    output [3:0] chunk_type     // Chunk type of (x, y)
);
    // Convert move to its x-offset
    function [2:0] dx (input [2:0] move);
        begin case (move)
            `LEFT: dx = -1;
            `RIGHT: dx = 1;
            default: dx = 0;
        endcase end
    endfunction

    // Convert move to its y-offset
    function [2:0] dy (input [2:0] move);
        begin case (move)
            `UP: dy = -1;
            `DOWN: dy = 1;
            default: dy = 0;
        endcase end
    endfunction

    // Map move to facing
    function [3:0] facing (input [2:0] move);
        begin case (move)
            `UP: facing = `PLAYER_UP;
            `DOWN: facing = `PLAYER_DOWN;
            `LEFT: facing = `PLAYER_LEFT;
            `RIGHT: facing = `PLAYER_RIGHT;
        endcase end
    endfunction

    reg [3:0] cur_map[9:0][9:0];    // Current map, the map to be displayed
    reg [3:0] env_map[9:0][9:0];    // Environment map, the map of walls, grounds, and targets

    reg [3:0] p_x, p_y;             // Player position
    reg [2:0] score = 2'd0;         // The number of boxes on targets
    reg [2:0] level = 3'd1;         // Current level
    reg [1:0] state = `INIT;        // Current state

    reg ready = 1'b0;               // Ready signal for game initialization



    // Retrieve the chunk type of (req_x, req_y) and return
    assign chunk_type = is_center ? cur_map[req_x][req_y] : `SIDE;



    // Game initialization
    integer i, j;
    always @ (posedge clk) begin
        if (state == `INIT) begin
            p_x <= 4'd1;
            p_y <= 4'd1;
            for (i = 0; i <= 9; i = i + 1) begin
                for (j = 0; j <= 9; j = j + 1) begin
                    if(i == 0 || i == 9 || j == 0 || j == 9) begin
                        cur_map[i][j] <= `WALL;
                        env_map[i][j] <= `WALL;
                    end
                    else if((i == 2 && j == 1) || (i == 1 && j == 4) || (i == 2 && j == 2) || (i == 2 && j == 3)) begin
                        cur_map[i][j] <= `BOX;
                        env_map[i][j] <= `GROUND;
                    end
                    else if((i == 3 && j == 1) || (i == 1 && j == 6) || (i == 3 && j == 2) || (i == 3 && j == 3)) begin
                        cur_map[i][j] <= `TARGET;
                        env_map[i][j] <= `TARGET;
                    end
                    else if(i == 1 && j == 1) begin
                        cur_map[i][j] <= `PLAYER_UP;
                        env_map[i][j] <= `GROUND;
                    end
                    else begin
                        cur_map[i][j] <= `GROUND;
                        env_map[i][j] <= `GROUND;
                    end
                end
            end
            ready <= 1'b1;
        end
    end



    // State machine: INIT
    // Initialize the game, wait for IP core
    always @ (posedge clk) begin
        if (state == `INIT) begin
            score <= 2'd0;
            if (ready) state <= `OPERATE;
        end
    end



    // State machine: OPERATE
    // Perform the moves, check game over
    wire [2:0] dest_x = p_x + dx(move);    // Destination x
    wire [2:0] dest_y = p_y + dy(move);    // Destination y
    wire [2:0] far_x = p_x + 2 * dx(move); // Far x
    wire [2:0] far_y = p_y + 2 * dy(move); // Far y
    
    always @ (posedge clk) begin
        if (state == `OPERATE) begin
            ready <= 1'b0;

            if (move == `RESET)                     // Reset the game
                state <= `INIT;
            else if (move != `NONE) begin
                case (cur_map[dest_x][dest_y])      // Player & box move
                    `GROUND, `TARGET: begin
                        cur_map[dest_x][dest_y] <= facing(move);
                        cur_map[p_x][p_y] <= env_map[p_x][p_y];
                        p_x <= dest_x;
                        p_y <= dest_y;
                    end
                    `BOX: begin
                        if (cur_map[far_x][far_y] == `GROUND
                        || cur_map[far_x][far_y] == `TARGET) begin
                            cur_map[far_x][far_y] <= `BOX;
                            cur_map[dest_x][dest_y] <= facing(move);
                            cur_map[p_x][p_y] <= env_map[p_x][p_y];
                            p_x <= dest_x;
                            p_y <= dest_y;
                        end

                        if (env_map[far_x][far_y] == `TARGET)   score <= score + 1;
                        if (env_map[dest_x][dest_y] == `TARGET) score <= score - 1;
                    end
                endcase
            end

            if (score == `BOX_NUM)                  // Level up
                state <= `LEVELUP;
        end
    end



    // State machine: LEVELUP
    // Move to the next level
    always @ (posedge clk) begin
        if (state == `LEVELUP) begin
            if (level == `MAX_LEVEL) begin
                level <= 3'd1;
                state <= `GAMEOVER;
            end else begin
                level <= level + 1;
                state <= `INIT;
            end
        end
    end



    // State machine: GAMEOVER
    // Game over, wait for reset
    always @ (posedge clk) begin
        if (state == `GAMEOVER) begin
            if (move == `RESET) begin
                level <= 3'd1;
                state <= `INIT;
            end
        end
    end
endmodule