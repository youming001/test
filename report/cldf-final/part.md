设计报告（包括设计说明、调试过程分析、核心模块模拟仿真时序图，操作说明，组内成员及工作说明、验证过程演示（含照片））
## 封面
## 目录

## 1 绪论
### 1.1 FPGA 及 verilog 
FPGA(field programmable gate array) ，是现场可编程逻辑门阵列，它是在PAL、GAL、CPLD等可编程器件的基础上进一步发展的产物。FPGA 是一种半定制电路，其在制造后可以根据所需的应用或功能要求重新编程，这既解决了定制电路的不足，又克服了原有可编程器件门电路数有限的缺点，因而，它拥有强大、全方面、多维度的可编程能力。
Verilog是一种硬件描述语言（HDL），用于描述电子系统和数字电路的结构和行为。它广泛应用于设计和验证集成电路（IC）、尤其是数字电路中的逻辑设计。Verilog可以用于描述电路的行为级、寄存器传输级（RTL）以及门级。

### 1.2 推箱子游戏设计
#### 1.2.1 推箱子游戏
推箱子是一款经典小游戏，玩家需要在一个有限空间内，将箱子推到指定位置上，当所有箱子都达到指定位置后，则游戏过关。
#### 1.2.2 游戏规则及设计
* 玩家可以上下左右移动
* 沿移动方向下一个方块为墙时，则玩家原地不同，而朝向随移动方向而给变
* 沿移动方向下一个方块为空地（含目标位置）时，玩家可以移动到该空地处
* 沿移动方向下一个方块为箱子时，如果再下一个方块为空地，则玩家可以推动箱子前进一格
* 游戏将在所有箱子到达指定位置后过关
在设计中，游戏处于开始界面时，按下空格键可以进入游戏。游戏中，可用键盘上的上下左右键来操作玩家的移动，并可进行推箱子操作。每关初始时会有四个箱子和四个目标位置，玩家将箱子推到目标位置得到一分，得到四分后通关，如果不慎操作陷入僵局，可以用 r 键来重新开始本关卡。关卡共有 5 关，难度逐渐递增，当通过所有关卡后，游戏将回到初始界面，此时按下空格键可以继续进行游戏。游戏进行时，关卡数和得分信息将实时显示在左侧两种七段数码管上。

### 1.3 核心设计模块：ps2、vgac、ip core 原理
#### ps2 键盘
PS/2 接口使用两根信号线，一根信号线传输时钟 PS2_CLK ，另一根传输数据 PS2_DAT。时钟信号主要用于指示数据线上的比特位在什么时候是有效的，我们在此主要考虑键盘向主机传送数据的情况。当 PS2_DAT 和 PS2_CLK 信号线都为高电平时，键盘才可以给主机发送信号。
当用户按键或松开时按键时，键盘以每帧11位的格式串行传送数据给主机，同时在PS2_CLK时钟信号上传输对应的时钟。第一位是开始位，后面跟8位数据位（低位在前），一个奇偶校验位和一位停止位。

<img src = "./ps2-sync.png" width = "600">

键盘通过PS2_DAT引脚发送的信息称为扫描码，每个扫描码可以由单个数据帧或连续多个数据帧构成。当按键被按下时送出的扫描码被称为通码，当按键被释放时送出的扫描码称为断码，特别的，在扩展键盘上按键被按下后，将发送一份额外扫描码来象征扩展位。每个键都有唯一的通码和断码，键盘所有键的扫描码组成的集合称为扫描码集，利用该扫描码集与键盘传出信息，我们可以得知按键的按下与断开情况，通过对不同情况的判定，传出相应值来象征不同操作。
<img src = "./ps2-1.png" width = "600">
<img src = "./ps2-2.png" width = "400">

#### vgac
图像的显示是以像素点为单位，显示器的分辨率是指屏幕每行有多少个像素及每帧有多少行。VGA显示器上每一个像素点可以很多种颜色，由R、G、B三种颜色构成。如果每个像素点采用12位二进制数表示，即RGB均用4bit表示，则此像素点一共可以显示4096种颜色。
VGA的时序主要包括行时序与场时序两个部分，其使用逐行扫描的方式来打印界面，行同步信号是一个负脉冲，行同步信号有效后，由RGB端送出当前行显示的各像素点的RGB电压值，当一帧显示结束后，由帧同步信号送出一个负脉冲，重新开始从屏幕的左上端开始显示下一帧图像。
<img src = "./vga-1.png" width = "600">

对于一个 640 · 480 的 VGA，有效地显示一行信号需要 800 个像素点的时间，有效显示一帧图像需要 525 行时间,因此，在 640 · 480的VGA上的一幅图像需要 420k 个像素点的时间,每秒扫描60帧共需要约 25M 个像素点的时间,因此，我们需要 25MHz 的时钟来驱动VGAC。
在实际应用中，在输入 25MHz 的时钟后，通过在每个扫描时序参数下给出对应的 rgb 数据和同步信号，即可实现画面显示。

#### IP核
IP核是 FPGA 中的数据块，我们可以在其中预先存下图片色彩信息，当使用时，通过传入时钟信号、读使能与地址，就可以调出相应的色彩信息进行传出。

### 1.4 开发板功能使用
* VGA 屏幕显示
* ps2 键盘
* IP核存储
* 两种七段数码管
* 两种 LED 灯

### 1.5 使用工具


## 2 设计说明
### 2.1 整体结构
<img src = "./struc.png" width = "600">

#### 输入输出
* 输入：时钟信号和键盘传入信号
* 输出： VGA 所需的 rgb 色彩信号以及同步信号、两种七段数码管及两种 LED 灯的驱动信号
#### 显示说明
我们使用了中心的 480 · 480 像素区块作为核心显示区域，该区域被分为 10 · 10区块，每个区块对应一个物体，其包含墙体、地面、目标位置、角色及箱子。
#### 程序逻辑
当有键盘信号输入时，LOGIC 模块将综合该信号以及当前地图信息开始处理，更新当前地图信息，并进行分数增减判定以及关卡切换。
时钟信号一直传入，VGAC 将接收时钟信号并以行、列地址的形式产生扫描时序参数。当地址传入 LOGIC 模块后，其将输出对应的区块信息至 RENDER 模块中，RENDER 模块接收该区块信息后，会结合具体地址从IP核中调取 rgb 数据并传出。随后，rgb 数据、扫描时序参数及同步信号被一同传出，在屏幕上实现显示功能。IP核在游戏开始前已存储好所需显示数据。
此外，两种七段数码管将实时显示关卡信息及得分情况；装饰用的 LED 灯会一直闪烁。
以上过程都通过 TOP 模块进行整合。

### 2.2 各模块介绍

#### TOP
游戏的顶层文件，例化子模块，负责处理各个模块之间的数据传输逻辑。其一重要功能为，将 VGAC 模块产生的扫描行、列地址拆分为所处区块的坐标信息和区块内坐标信息，这两个坐标信息唯一对应一个行列地址，其中，区块的坐标信息传入 LOGIC 模块作判定，区块内坐标信息传入 RENDER 模块辅助显示。
```verilog
`include "PARAMS.v"

module TOP (
    input clk,             // 100MHz clock
    input rstn,            // Reset signal (low active)
    input ps2_clk,         // PS2 Clock
    input ps2_data,        // PS2 Data
    output [3:0] AN,       // 7-segment Anode
    output [7:0] SEGMENT,  // 7-segment Segment
    output [7:0] LED,      // LED
    output [3:0] r, g, b,  // VGA RGB Output
    output hs,             // VGA Horizontal Sync
    output vs,             // VGA Vertical Sync
    output SEG_CLK,        // 7-segment Clock
    output SEG_CLR,        // 7-segment Clear
    output SEG_DT,         // 7-segment Data
    output SEG_EN,         // 7-segment Enable
    output LED_CLK,        // LED Clock
    output LED_CLR,        // LED Clear
    output LED_DT,         // LED Data
    output LED_EN          // LED Enable
);
    // Clock Division
    wire [31:0] clk_div;
    CLKDIV clkdiv (.clk(clk), .rst(1'b0), .clk_div(clk_div));


    // VGA Control
    wire [9:0] col_addr; // X
    wire [8:0] row_addr; // Y
    wire [11:0] vgac_in;
    wire rdn;
    VGAC vgac (
        .clk(clk_div[1]),
        .clrn(rstn),
        .din(vgac_in),
        .col_addr(col_addr),
        .row_addr(row_addr),
        .r(r), .g(g), .b(b),
        .hs(hs), .vs(vs), .rdn(rdn)
    );


    // LOGIC
    wire [2:0] move;
    wire [3:0] chunk_type;
    wire [3:0] req_x = (col_addr - 80) / 48;
    wire [3:0] req_y = row_addr / 48;
    LOGIC logic (
        .clk(clk),
        .is_center(col_addr >= 80 && col_addr <= 559),
        .req_x(req_x),
        .req_y(req_y),
        .move(move),
        .chunk_type(chunk_type)
    );


    // STATIC - Static images, e.g. START, GAMEOVER
    wire [11:0] static_out;
    STATIC static (
        .clk(clk_div[1]),
        .v_X(col_addr),
        .v_Y(row_addr),
        .dout(static_out)
    );


    // RENDER
    wire [5:0] sp_x = (col_addr - 80 + 48 * 2) % 48; // 48 * 2 is to avoid negative value
    wire [5:0] sp_y = row_addr % 48;
    wire [11:0] render_out;
    RENDER render (
        .clk(clk_div[1]),
        .sp_x(sp_x),
        .sp_y(sp_y),
        .chunk_type(chunk_type),
        .dout(render_out)
    );
    assign vgac_in = logic.state == `START ? static_out : render_out;


    // Level Display
    LVDISP lvdisp (
        .scan(clk_div[18:17]),
        .din({1'b0, logic.level}),
        .SEGMENT(SEGMENT),
        .AN(AN)
    );


    // Score Display
    SCDISP scdisp (
        .clk(clk),
        .din({1'b0, logic.score}),
        .SEG_CLK(SEG_CLK),
        .SEG_CLR(SEG_CLR),
        .SEG_DT(SEG_DT),
        .SEG_EN(SEG_EN)
    );


    // LED Display
    LEDDISP leddisp (
        .clk(clk),
        .LED(LED),
        .LED_CLK(LED_CLK),
        .LED_DT(LED_DT),
        .LED_EN(LED_EN),
        .LED_CLR(LED_CLR)
    );


    // CONTROL
    KEYBOARD keyboard (
        .clk(clk),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .move(move)
    );
endmodule

```

#### Logic
游戏的核心逻辑模块，其接收键盘传来的移动信息，综合所存储的地图信息进行处理，其将会判断玩家是否可移动及箱子是否可推动，并根据操作的合法性来对当前地图信息进行更新，并进行分数增减判定以及用状态机来实现关卡切换。LOGIC模块也将接收区块的坐标信息来传出区块类别至 RENDER 模块，作为显示所用的数据。
``` verilog
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
    function [3:0] dx (input [2:0] move);
        begin case (move)
            `LEFT: dx = -1;
            `RIGHT: dx = 1;
            default: dx = 0;
        endcase end
    endfunction

    // Convert move to its y-offset
    function [3:0] dy (input [2:0] move);
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


    reg [2:0] map_mem[0:100 * `MAX_LEVEL]; // Map memory
    reg [3:0] cur_map[9:0][9:0];           // Current map, the map to be displayed
    reg [3:0] env_map[9:0][9:0];           // Environment map: walls, grounds, and targets

    reg [3:0] p_x, p_y;                    // Player position
    reg [2:0] score = 3'd0;                // The number of boxes on targets
    reg [2:0] level = 3'd1;                // Current level
    reg [1:0] state = `START;              // Current state



    // Retrieve requested data and return
    assign chunk_type = is_center ? cur_map[req_x][req_y] : `SIDE;



    // Initialize map memory
    initial $readmemh("level.mem", map_mem);



    // Game logic
    integer i, j;                          // Auxiliary variables
    wire [3:0] dest_x = p_x + dx(move);    // Destination x
    wire [3:0] dest_y = p_y + dy(move);    // Destination y
    wire [3:0] far_x = p_x + 2 * dx(move); // Far x
    wire [3:0] far_y = p_y + 2 * dy(move); // Far y

    always @ (posedge clk) begin
        // State machine: START
        // Start screen, wait for [space] key
        if (state == `START) begin
            score <= 3'b0;
            if (move == `PLAY) begin
                state <= `INIT;
            end
        end


        // State machine: INIT
        // Initialize the game, wait for IP core
        if (state == `INIT) begin
            score <= 3'd0;
            state <= `OPERATE;

            for (i = 0; i < 10; i = i + 1) begin
                for (j = 0; j < 10; j = j + 1) begin
                    case (map_mem[(level - 1) * 100 + i + j * 10])
                        3'd1: begin
                            cur_map[i][j] <= `PLAYER_UP;
                            env_map[i][j] <= `GROUND;
                            p_x <= i;
                            p_y <= j;
                        end
                        3'd2:    begin cur_map[i][j] <= `BOX;    env_map[i][j] <= `GROUND; end
                        3'd3:    begin cur_map[i][j] <= `TARGET; env_map[i][j] <= `TARGET; end
                        3'd4:    begin cur_map[i][j] <= `WALL;   env_map[i][j] <= `WALL;   end
                        default: begin cur_map[i][j] <= `GROUND; env_map[i][j] <= `GROUND; end
                    endcase
                end
            end
        end



        // State machine: OPERATE
        // Perform the moves, check game over
        if (state == `OPERATE) begin
            if (move == `RESET)                     // Reset the game
                state <= `INIT;
            else case (cur_map[dest_x][dest_y])     // Player & box move
                `GROUND, `TARGET: begin
                    cur_map[dest_x][dest_y] <= facing(move);
                    cur_map[p_x][p_y] <= env_map[p_x][p_y];
                    p_x <= dest_x;
                    p_y <= dest_y;
                end
                `BOX: begin
                    if (cur_map[far_x][far_y] == `GROUND || cur_map[far_x][far_y] == `TARGET) begin
                        cur_map[far_x][far_y] <= `BOX;
                        cur_map[dest_x][dest_y] <= facing(move);
                        cur_map[p_x][p_y] <= env_map[p_x][p_y];
                        p_x <= dest_x;
                        p_y <= dest_y;

                        if (env_map[dest_x][dest_y] == `TARGET && env_map[far_x][far_y] != `TARGET) score <= score - 1;
                        if (env_map[dest_x][dest_y] != `TARGET && env_map[far_x][far_y] == `TARGET) score <= score + 1;
                    end else cur_map[p_x][p_y] <= facing(move);
                end
                `WALL: cur_map[p_x][p_y] <= facing(move);
            endcase

            if (score == `BOX_NUM)                  // Level up
                state <= `LEVELUP;
        end



        // State machine: LEVELUP
        // Move to the next level
        if (state == `LEVELUP) begin
            if (level == `MAX_LEVEL) begin
                level <= 3'd1;
                state <= `START;
            end else begin
                level <= level + 1;
                state <= `INIT;
            end
        end
    end
endmodule
```

#### RENDER
游戏的显示模块，负责接收一个坐标对应的区块种类及具体区块内坐标信息，由此与IP核交互，得到 rgb 显示信息并传出。
```verilog
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
endmodule

```

#### keyboard
对传入的键盘数据进行判断，驱动部分提取处按键的断开、扩展和具体扫描码封装为一个数据包，在对该数据包进行解析后，可得到具体的按键信息，并将其转化为一个时钟周期的移动信号传出。
```verilog
`include "PARAMS.v"

module KEYBOARD(
    input clk,
    input ps2_clk,
    input ps2_data,
    output [2:0] move
);
    localparam CODE_SPACE = 8'h29;  // `PLAY
    localparam CODE_R     = 8'h2D;  // `RESET
    localparam CODE_UP    = 8'h75;
    localparam CODE_DOWN  = 8'h72;
    localparam CODE_LEFT  = 8'h6B;
    localparam CODE_RIGHT = 8'h74;

    wire [9:0] data;  // data_expand, data_break, temp_data
    wire [7:0] data_key = data[7:0];
    wire data_expand    = data[9];
    wire data_break     = data[8];
    
    reg [2:0] key     = 3'b0;
    reg [2:0] old_key = 3'b0;
    reg [2:0] state   = 3'b0;

    assign move = state;

    wire ready;
    DRIVE drive (
        .clk(clk),
        .rst(1'b0),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .data_out(data),
        .ready(ready)
    );

    always @ (posedge clk) begin
        if (data_break == 1'b0 && data_expand == 1'b0) begin
            if (ready) begin
                case (data_key)
                    CODE_SPACE: key <= `PLAY;
                    CODE_R:     key <= `RESET;
                    default:    key <= `NONE;
                endcase
            end else key <= `NONE;
        end else if (data_break == 1'b0 && data_expand == 1'b1) begin
            if (ready) begin
                case (data_key)
                    CODE_UP:    key <= `UP;
                    CODE_DOWN:  key <= `DOWN;
                    CODE_LEFT:  key <= `LEFT;
                    CODE_RIGHT: key <= `RIGHT;
                    default:    key <= `NONE;
                endcase
            end else key <= `NONE;
        end else key <= `NONE;
    end

    always @ (posedge clk) begin
        if (|key && ~|old_key) state <= key;
        else state <= `NONE;
        old_key <= key;
    end
endmodule



module DRIVE (
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,
    output [9:0] data_out,
    output ready
);

    reg ps2_clk_flag0, ps2_clk_flag1, ps2_clk_flag2;
    wire negedge_ps2_clk;

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            ps2_clk_flag0 <= 1'b0;
            ps2_clk_flag1 <= 1'b0;
            ps2_clk_flag2 <= 1'b0;
        end else begin
            ps2_clk_flag0 <= ps2_clk;
            ps2_clk_flag1 <= ps2_clk_flag0;
            ps2_clk_flag2 <= ps2_clk_flag1;
        end
    end

    assign negedge_ps2_clk = !ps2_clk_flag1 & ps2_clk_flag2;
    reg [3:0] num;

    always @ (posedge clk or posedge rst) begin
        if (rst)                  num <= 4'd0;
        else if (num == 4'd11)    num <= 4'd0;
        else if (negedge_ps2_clk) num <= num +1'b1;
    end

    reg negedge_ps2_clk_shift;
    always @ (posedge clk) negedge_ps2_clk_shift <= negedge_ps2_clk;

    reg [7:0] temp_data;

    always @ (posedge clk or posedge rst) begin
        if (rst) temp_data <= 8'd0;
        else if (negedge_ps2_clk_shift) begin
            case(num)
                4'd2: temp_data[0] <= ps2_data;
                4'd3: temp_data[1] <= ps2_data;
                4'd4: temp_data[2] <= ps2_data;
                4'd5: temp_data[3] <= ps2_data;
                4'd6: temp_data[4] <= ps2_data;
                4'd7: temp_data[5] <= ps2_data;
                4'd8: temp_data[6] <= ps2_data;
                4'd9: temp_data[7] <= ps2_data;
            endcase
        end
    end

    reg data_break, data_done, data_expand;
    reg [9:0] data;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            data_break <= 1'b0;
            data <= 10'd0;
            data_done <= 1'b0;
            data_expand <= 1'b0;
        end else if (num == 4'd11) begin
            if (temp_data == 8'hE0)
                data_expand <= 1'b1;
            else if (temp_data == 8'hF0)
                data_break <= 1'b1;
            else begin
                data <= {data_expand, data_break, temp_data};
                data_done <= 1'b1;
                data_expand <= 1'b0;
                data_break <= 1'b0;
            end
        end else begin
            data <= data;
            data_done <= 1'b0;
            data_expand <= data_expand;
            data_break <= data_break;
        end
    end

    assign data_out = data;
    assign ready = data_done;
endmodule
```

#### VGAC
VGA显示所需驱动，其接收时钟信号，并以行、列地址的方式传出扫描时序参数及同步信号，并拆分 12 位显示数据为 3 个 4 位 r、g、b 数据进行输出
```verilog
module VGAC (
    input clk,                  // 25MHz VGA clock
    input clrn,                 // Reset signal (low active)
    input [11:0] din,           // Color data, rrrr_gggg_bbbb

    output reg [8:0] row_addr,  // Row 480px
    output reg [9:0] col_addr,  // Col 640px
    output reg [3:0] r, g, b,   // VGA RGB444 output
    output reg rdn,             // Read enable (low active)
    output reg hs,              // h_sync
    output reg vs               // v_sync
);
    // hcnt: horizontal counter (0-799)
    reg [9:0] hcnt;
    always @ (posedge clk) begin
        if (!clrn) hcnt <= 0;
        else if (hcnt == 799) hcnt <= 0;
        else hcnt <= hcnt + 1;
    end

    // vcnt: vertical counter (0-524)
    reg [9:0] vcnt;
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) vcnt <= 0;
        else if (hcnt == 799) begin
            if (vcnt == 524) vcnt <= 0;
            else vcnt <= vcnt + 1;
        end
    end

    wire [9:0] row    =  vcnt - 35;      // Row address
    wire [9:0] col    =  hcnt - 143;     // Col address
    wire       h_sync = (hcnt > 95);     //  96 -> 799
    wire       v_sync = (vcnt > 1);      //   2 -> 524
    wire       read   = (hcnt > 142) &&  // 143 -> 782
                        (hcnt < 783) &&  //        640px
                        (vcnt > 34)  &&  //  35 -> 514
                        (vcnt < 515);    //        480 rows

    // vga signals
    always @ (posedge clk) begin
        row_addr <=  row[8:0]; // RAM row address
        col_addr <=  col;      // RAM col address
        rdn      <= ~read;     // Read enable (low active)
        hs       <=  h_sync;   // Horizontal sync
        vs       <=  v_sync;   // Vertical sync
        r        <=  rdn ? 4'h0 : din[11:8];   // 4-bit Red
        g        <=  rdn ? 4'h0 : din[7:4];    // 4-bit Green
        b        <=  rdn ? 4'h0 : din[3:0];    // 4-bit Blue
    end
endmodule
```

#### CLKDIV
接收时钟信号，产生时钟分沿信号
```v
module CLKDIV (
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

```

#### PARAMS
存储所有的参数信息
```v
// VGA
`define WIDTH  640
`define HEIGHT 480

// STATE ENUM
`define INIT    2'b00
`define OPERATE 2'b01
`define LEVELUP 2'b10
`define START   2'b11

// SPRITE
`define SPRITE_SIZE   48

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
`define PLAY  3'b110

// GAME CONSTANTS
`define MAX_LEVEL 5
`define BOX_NUM   4
```

#### 辅助显示模块
* STATIC：初始界面显示
* LEDDISP：装饰用 LED 显示
* LVDISP：关卡显示
* SCDISP：分数显示

## 3 调试过程与仿真
### 3.1 上板验证及调试过程
* always 块竞争

* 贴图异常

### 3.2 仿真
* Logic
在初步设计时，为对LOGIC模块进行单独仿真，这里在其中初始化了如下地图，其中"#"表示墙，" "表示空地，"$"表示箱子，"."表示目标位置"@"表示角色
```
##########
#@       #
# $.     #
# $.     #
# $.     #
#$       #
#        #
#.       #
#        #
##########
```
<img src = "./logic_tb-1.png" width = "600">

先操作玩家向两个方向墙体进行移动，发现其坐标（player_x、player_y）未改变，而玩家朝向状态（player_state）改变，这符合我们的设计预期。
再操作其向右推箱子至目标位置，发现得分（cur_score）从 0 变为 1 ，说明得分逻辑正常。

<img src = "./logic_tb-2.png" width = "600">

操作玩家推箱子直至通关，发现当得分为4之后，触发通关条件，分数清零，玩家位置重置，此时发生了过关的关卡重置，这说明过关逻辑正常，以此完成了对 LOGIC 模块的单独仿真测试。

* TOP

### 3.3 模拟
* PS2键盘
该模块通过将上下左右键及 R（重新开始）、空格键分别控制一数字为1~6，显示在七段数码管上进行模拟，当依次按下上、下、左、右、R、空格后，分别得到如下结果。
<img src = "./key-1.jpg" width = "300">
<img src = "./key-2.jpg" width = "300">
<img src = "./key-3.jpg" width = "300">
<img src = "./key-4.jpg" width = "300">
<img src = "./key-5.jpg" width = "300">
<img src = "./key-6.jpg" width = "300">

这符合我们的预期。

## 4 验证过程演示
游戏初始界面如下
<img src = "./play-1.jpg" width = "600">
按下空格进入游戏，如下为第一关初始情况
<img src = "./play-2.jpg" width = "600">
此时关卡显示为 1，得分显示为 0
<img src = "./play-3.jpg" width = "600">
通过键盘操作通关，游玩片刻后，仅差一个箱子到位即可通关
<img src = "./play-4.jpg" width = "600">
此时分数显示为3
<img src = "./play-5.jpg" width = "600">
推箱子通关后，进入第二关
<img src = "./play-6.jpg" width = "600">
其初始化为关卡显示为 2，得分显示为 0
<img src = "./play-7.jpg" width = "600">
随着进一步的游玩，游戏推进到了最后一关第五关，此时已经有些难度了
<img src = "./play-8.jpg" width = "600">
关卡显示为 5，得分显示为 1
<img src = "./play-9.jpg" width = "600">

## 5 组内成员及工作说明
