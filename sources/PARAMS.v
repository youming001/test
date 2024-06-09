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
`define PLAYER_UP     3'b000
`define PLAYER_DOWN   3'b001
`define PLAYER_LEFT   3'b010
`define PLAYER_RIGHT  3'b011
`define BOX           3'b100
`define TARGET        3'b101
`define WALL          3'b110
`define GROUND        3'b111

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