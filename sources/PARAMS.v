// VGA
`define WIDTH  640
`define HEIGHT 480

// STATE ENUM
`define INIT     2'b00
`define OPERATE  2'b01
`define LEVELUP  2'b10
`define GAMEOVER 2'b11

// SPRITE
`define SPRITE_WIDTH  48
`define SPRITE_HEIGHT 48

// SPRITE ENUM
`define PLAYER_UP     4'b0000
`define PLAYER_DOWN   4'b0001
`define PLAYER_LEFT   4'b0010
`define PLAYER_RIGHT  4'b0011
`define BOX           4'b0100
`define TARGET        4'b0101
`define WALL          4'b0110
`define GROUND        4'b0111
`define SIDE          4'b1000

// OPERATION ENUM
`define NONE  3'b000
`define UP    3'b001
`define DOWN  3'b010
`define LEFT  3'b011
`define RIGHT 3'b100
`define RESET 3'b101

// GAME CONSTANTS
`define MAX_LEVEL 4
`define BOX_NUM   4
`define MAP_SIZE  10