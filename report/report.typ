#import "@preview/tablex:0.0.8": tablex

#let underlined_cell(content, color: black) = tablex(
    align: center + horizon,
    stroke: 0pt,
    inset: 0.75em,
    map-hlines: h => {
        if (h.y > 0) {
            (..h, stroke: 0.5pt + color)
        } else { h }
    },
    columns: (1fr),
    content,
)

#let figurex(
    src,
    top: 0pt,
    bottom: 0pt,
    x: 0pt,
    caption,
    width: 100%
) = {
    show figure.caption: it => {
        set text(size: 0.9em, fill: luma(100), weight: 700)
        it
        v(0.2em)
    }
    set figure.caption(separator: ": ")
    figure(
        box(pad(top: top, bottom: bottom, x: x, image(src)), width: width),
        supplement: [图],
        caption: if caption == "" {none} else {text(weight: 400, caption)}
    )
}

#let codex(src, lang: none) = {
    let code = read(src)
    if code.ends-with("\n") {
        code = code.slice(0, code.len() - 1)
    }
    align(left)[
        #set par(hanging-indent: 0em)
        #block(
            width: 100%,
            stroke: 0.5pt + luma(190),
            radius: 1pt,
            inset: 8pt,
            pad(raw(lang: lang, block: true, code), left: -1.5em)
        )
    ]
}


#let font_serif = ("New Computer Modern", "Georgia", "Nimbus Roman No9 L", "Songti SC", "Noto Serif CJK SC", "Source Han Serif SC", "Source Han Serif CN", "STSong", "AR PL New Sung", "AR PL SungtiL GB", "NSimSun", "SimSun", "TW\-Sung")
#let font_sans_serif = ("Noto Sans", "Helvetica Neue", "Helvetica", "Nimbus Sans L", "Arial", "Liberation Sans", "PingFang SC", "Hiragino Sans GB", "Noto Sans CJK SC", "Source Han Sans SC", "Source Han Sans CN", "Microsoft YaHei")
#let font_mono = ("Consolas", "Monaco")

#show raw: set text(font: (..font_mono, ..font_sans_serif))
#show math.equation: set text(weight: 400)
#show par: set block(above: 1.6em, below: 1.6em)
#show list: set block(above: 1.6em, below: 1.6em)
#show enum: pad.with(y: .8em)
#show heading.where(level: 1): body => {
    set text(weight: "bold", size: 1.3em)
    set align(center)
    pad(bottom: 1em, body)
}
#show heading.where(level: 2): set pad(top: .6em)
#show heading.where(level: 3): set pad(top: .3em, bottom: .3em)

#set page(numbering: "1", number-align: center, margin: (left: 17mm, right: 17mm, top: 30mm, bottom: 30mm))
#set text(font: font_serif, lang: "cn", size: 12pt)
#set par(leading: 1.2em, justify: true)
#set table(align: center + horizon, stroke: 0.5pt, inset: 10pt)
#set heading(numbering: (..args) => {
    let nums = args.pos()
    if nums.len() == 1 { return numbering("I ", nums.at(0)) }
    else if nums.len() == 2 { return numbering("1 ", nums.at(1)) }
    else { return numbering("1.1 ", nums.at(1), nums.at(2)) }
})


// COVER PAGE
#v(1fr)
#align(center, image("./assets/ZJU-Banner.png", width: 48%))
#v(6em)
#align(center)[
    #set text(size: 20pt, weight: "bold")
    *《计算机逻辑设计基础》课程设计报告*
]
#v(1em)
#align(center, box(width: 70%)[
    #set text(size: 1.2em)  
    #tablex(
        columns: (8em, 1fr),
        align: center + horizon,
        stroke: 0pt,
        inset: 1pt,
        map-cells: cell => {
            if (cell.x == 0) { underlined_cell(cell.content, color: white) }
            else { underlined_cell(cell.content, color: black) }
        },
        [*题　　　目*], [*FPGA推箱子游戏*],
        [小组成员一], "",
        [学　　　号], "",
        [专　　　业], "计算机科学与技术",
        [学　　　院], "竺可桢学院",
        [小组成员二], "汪昕",
        [学　　　号], "3230101888",
        [专　　　业], "计算机科学与技术",
        [学　　　院], "竺可桢学院",
    )
])
#v(.8fr)
#align(center)[
    #set text(size: 1.2em, weight: "bold")
    #v(1em)
    #datetime.today().display("[year]年[month]月[day]日")
]
#v(1fr)
#pagebreak()


// TOC
#outline(indent: true, title: "目录")
#pagebreak()
#set grid(align: bottom, columns: 2, gutter: 10pt)
#set par(hanging-indent: -2em)
#show par: pad.with(left: 2em)
#show heading: pad.with(left: -2em)
#set list(body-indent: -1.2em, indent: -1.8em)
#show list.item: set par(hanging-indent: 0em)


// CONTENT
= 绪论

== FPGA 及 Verilog 

FPGA（Field Programmable Gate Array），是现场可编程逻辑门阵列，它是在 PAL、GAL、CPLD 等可编程器件的基础上进一步发展的产物。FPGA 是一种半定制电路，其在制造后可以根据所需的应用或功能要求重新编程，这既解决了定制电路的不足，又克服了原有可编程器件门电路数有限的缺点，因而，它拥有强大、全方面、多维度的可编程能力。

Verilog 是一种硬件描述语言（HDL），用于描述电子系统和数字电路的结构和行为。它广泛应用于设计和验证集成电路（IC）、尤其是数字电路中的逻辑设计。Verilog 可以用于描述电路的行为级、寄存器传输级（RTL）以及门级。

== 推箱子游戏设计

=== 推箱子游戏

推箱子是一款经典小游戏，玩家需要在一个有限空间内，将箱子推到指定位置上，当所有箱子都达到指定位置后，则游戏过关。

=== 游戏规则及设计

 - 玩家可以上下左右移动
 - 沿移动方向下一个方块为墙时，则玩家原地不同，而朝向随移动方向而给变
 - 沿移动方向下一个方块为空地（含目标位置）时，玩家可以移动到该空地处
 - 沿移动方向下一个方块为箱子时，如果再下一个方块为空地，则玩家可以推动箱子前进一格
 - 游戏将在所有箱子到达指定位置后过关

在设计中，游戏处于开始界面时，按下空格键可以进入游戏。游戏中，可用键盘上的上下左右键来操作玩家的移动，并可进行推箱子操作。每关初始时会有四个箱子和四个目标位置，玩家将箱子推到目标位置得到一分，得到四分后通关，如果不慎操作陷入僵局，可以用 R 键来重新开始本关卡。关卡共有 5 关，难度逐渐递增，当通过所有关卡后，游戏将回到初始界面，此时按下空格键可以继续进行游戏。游戏进行时，关卡数和得分信息将实时显示在左侧两种七段数码管上。

== 关键设计模块：PS/2、VGAC、IP 核原理

=== PS/2 键盘

PS/2 接口使用两根信号线，一根信号线传输时钟 PS2_CLK ，另一根传输数据 PS2_DAT。时钟信号主要用于指示数据线上的比特位在什么时候是有效的，我们在此主要考虑键盘向主机传送数据的情况。当 PS2_DAT 和 PS2_CLK 信号线都为高电平时，键盘才可以给主机发送信号。

当用户按键或松开时按键时，键盘以每帧 11 位的格式串行传送数据给主机，同时在 PS2_CLK 时钟信号上传输对应的时钟。第一位是开始位，后面跟 8 位数据位（低位在前），一位奇偶校验位和一位停止位。

#figurex("./assets/ps2-sync.png", "PS/2 信号", width: 55%)

键盘通过 PS2_DAT 引脚发送的信息称为扫描码，每个扫描码可以由单个数据帧或连续多个数据帧构成。当按键被按下时送出的扫描码被称为通码，当按键被释放时送出的扫描码称为断码，特别的，在扩展键盘上按键被按下后，将发送一份额外扫描码来象征扩展位。每个键都有唯一的通码和断码，键盘所有键的扫描码组成的集合称为扫描码集，利用该扫描码集与键盘传出信息，我们可以得知按键的按下与断开情况，通过对不同情况的判定，传出相应值来象征不同操作。

#grid(
    columns: (1.8fr, 1fr),
    gutter: -2em,
    figurex("./assets/ps2-1.png", "主键盘扫描码"),
    figurex("./assets/ps2-2.png", "小键盘扫描码")
)

#pagebreak()

=== VGAC

图像的显示是以像素点为单位，显示器的分辨率是指屏幕每行有多少个像素及每帧有多少行。VGA 显示器上每一个像素点可以很多种颜色，由 R、G、B 三种颜色构成。如果每个像素点采用 12 位二进制数表示，即 R、G、B 均用 4bit 表示，则此像素点一共可以显示 $2^12=4096$ 种颜色。

VGA 的时序主要包括行时序与场时序两个部分，其使用逐行扫描的方式来打印界面，行同步信号是一个负脉冲，行同步信号有效后，由 RGB 端送出当前行显示的各像素点的 RGB 电压值，当一帧显示结束后，由帧同步信号送出一个负脉冲，重新开始从屏幕的左上端开始显示下一帧图像。

#figurex("./assets/vga-1.png", "VGA 时序", width: 110%)

对于一个 $640 times 480$ 的 VGA，有效地显示一行信号需要 800 个像素点的时间，有效显示一帧图像需要 525 行时间，因此，在 $640 times 480$ 的 VGA 上的一幅图像需要 420k 个像素点的时间，每秒扫描 60 帧共需要约 25M 个像素点的时间，因此，我们需要 25MHz 的时钟来驱动 VGAC。

在实际应用中，在输入 25MHz 的时钟后，通过在每个扫描时序参数下给出对应的 RGB 数据和同步信号，即可实现画面显示。

=== IP 核

IP 核是 FPGA 中的数据块，我们可以在其中预先存下图片色彩信息，当使用时，通过传入时钟信号、读使能与地址，就可以调出相应的色彩信息进行传出。

// TODO

== 开发板功能使用

 - VGA 屏幕显示
 - PS/2 键盘
 - IP 核存储
 - 两种七段数码管
 - 两种 LED 灯

// TODO

== 使用工具

// TODO

#pagebreak()

= 设计说明

== 整体结构

#figurex("./assets/struc.png", "整体结构", width: 50%)

// TODO

=== 输入输出

 - *输入*：时钟信号和键盘传入信号
 - *输出*：VGA 驱动所需的 RGB 色彩信号以及同步信号、两种七段数码管及两种 LED 灯的驱动信号

=== 显示说明

我们使用了中心的 $480 times 480$ 像素区块作为核心显示区域，该区域被分为 $10 times 10$ 区块，每个区块对应一个物体，其包含墙体、地面、目标位置、角色及箱子。

=== 程序逻辑

当有键盘信号输入时，LOGIC 模块将综合该信号以及当前地图信息开始处理，更新当前地图信息，并进行分数增减判定以及关卡切换。

时钟信号一直传入，VGAC 将接收时钟信号并以行、列地址的形式产生扫描时序参数。当地址传入 LOGIC 模块后，其将输出对应的区块信息至 RENDER 模块中，RENDER 模块接收该区块信息后，会结合具体地址从IP核中调取 RGB 数据并传出。随后，RGB 数据、扫描时序参数及同步信号被一同传出，在屏幕上实现显示功能。IP 核在游戏开始前已存储好所需显示数据。

此外，两种七段数码管将实时显示关卡信息及得分情况；装饰用的 LED 灯会一直闪烁。

以上过程都通过 TOP 模块进行整合。

== 模块介绍

=== TOP

游戏的顶层文件，例化子模块，负责处理各个模块之间的数据传输逻辑。其一重要功能为，将 VGAC 模块产生的扫描行、列地址拆分为所处区块的坐标信息和区块内坐标信息，这两个坐标信息唯一对应一个行列地址，其中，区块的坐标信息传入 LOGIC 模块作判定，区块内坐标信息传入 RENDER 模块辅助显示。

#codex("./src/sources/TOP.v", lang: "verilog")

=== RENDER

游戏的显示模块，负责接收一个坐标对应的区块种类及具体区块内坐标信息，计算地址并与 IP 核交互，得到 RGB 显示信息并传出。

#codex("./src/sources/RENDER.v", lang: "verilog")

=== LOGIC

游戏的核心逻辑模块，其本质为一个状态机。状态机核心部分是 OPERATE 状态，该状态为关卡运行时所处状态，此时该模块接收键盘传来的移动信息，综合所存储的地图信息进行处理，其将会判断玩家是否可移动及箱子是否可推动，并对当前地图信息及得分进行更新，并判定过关情况。其余模块负责关卡的切换工作。在以上操作基础上，LOGIC模块接收区块的坐标信息来传出区块类别至 RENDER 模块，作为显示所用的数据。

#codex("./src/sources/LOGIC.v", lang: "verilog")

=== KEYBOARD

对传入的键盘数据进行判断，驱动部分提取处按键的断开、扩展和具体扫描码封装为一个数据包，在对该数据包进行解析后，可得到具体的按键信息，并将其转化为时长一个时钟周期的移动信号传出。

#codex("./src/sources/KEYBOARD.v", lang: "verilog")

=== VGAC

VGA 显示所需驱动，其接收时钟信号，并以行、列地址的方式传出扫描时序参数及同步信号，并拆分 12 位显示数据为 3 个 4 位 R、G、B 数据进行输出。

#codex("./src/sources/VGAC.v", lang: "verilog")

=== CLKDIV

接收时钟信号，产生时钟分沿信号，以供不同模块使用。

#codex("./src/sources/CLKDIV.v", lang: "verilog")

=== PARAMS

存储所有的参数信息，可被其他模块调用。

#codex("./src/sources/PARAMS.v", lang: "verilog")

=== 辅助显示模块

 - *STATIC*：初始界面显示
 - *LEDDISP*：装饰用 LED 显示
 - *LVDISP*：关卡显示
 - *SCDISP*：分数显示

#pagebreak()

= 调试过程与仿真

== 上板验证及调试过程

 - always 块竞争
 - 贴图异常

// TODO

== 仿真

=== LOGIC 模块

在初步设计时，为对 LOGIC 模块进行单独仿真，这里在其中初始化了如下地图，其中“`#`”表示墙，“` `”表示空地，“`$`”表示箱子，“`.`”表示目标位置，“`@`”表示角色。在随后的测试中，将通过更改玩家移动信息（move），来对该模块进行仿真验证。

#align(center)[
    #set par(hanging-indent: 0em, leading: .5em)
    #set text(tracking: .1em)
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
]

#h(2em)

#figurex("./assets/logic_tb-1.png", "LOGIC 模块仿真-1", width: 100%)

先操作玩家向两个有墙体的方向进行移动，发现其坐标（player_x、player_y）未改变，而玩家朝向状态 player_state 改变，这符合我们的设计预期。

再操作其向右推箱子至目标位置，发现得分 cur_score 从 0 变为 1，说明得分逻辑正常。

#figurex("./assets/logic_tb-2.png", "LOGIC 模块仿真-2", width: 110%)

操作玩家推箱子直至通关，发现当得分 cur_score 为 4 之后，触发通关条件，分数清零，玩家位置重置，说明此时发生了过关的关卡重置，那么过关逻辑正常，以此完成了对 LOGIC 模块的单独仿真测试。

=== TOP 模块

// TODO

== 模拟

=== PS/2 键盘

该模块通过将上下左右键及 R（重新开始）、空格键分别控制一数字为 1\~6 ，显示在七段数码管上进行模拟，当依次按下上、下、左、右、R、空格后，分别得到如下结果。

#grid(
    columns: 3,
    figurex("./assets/key-1.jpg", "上键"),
    figurex("./assets/key-2.jpg", "下键"),
    figurex("./assets/key-3.jpg", "左键"),
    figurex("./assets/key-4.jpg", "右键"),
    figurex("./assets/key-5.jpg", "R 键"),
    figurex("./assets/key-6.jpg", "空格键"),
)

这说明键盘可以正常将按键信息转化为我们所需要的信号。

#pagebreak()

= 验证过程演示

将生成的 bit 文件下载到实验板上，现在显示为游戏初始界面。

#figurex("./assets/play-1.jpg", "游戏初始界面", width: 70%)

按下空格键进入游戏，如下为第一关初始情况，一关内有四个箱子和四个目标位置。

#figurex("./assets/play-2.jpg", "第一关初始情况", width: 70%)

此时暂未对角色进行任何操作，实验板左上四个小七段数码管显示 L - 01，表示当前正处于第一关；下方的七段数码管显示 ScorE - 00，表示现得分为 0。

#figurex("./assets/play-3.jpg", "关卡信息显示-1", width: 70%)

通过键盘操作角色上下左右移动，推动箱子到指定位置，游玩片刻后，得到如下情况，此时只需操纵玩家向上移动并推动箱子到指定位置即可过关。

#figurex("./assets/play-4.jpg", "仅差一个箱子到位即可通关", width: 70%)

此时分数显示为 3，关卡数显示为 1。

#figurex("./assets/play-5.jpg", "关卡信息显示-2", width: 70%)

向上推动箱子，箱子全都处于目标位置，触发通关，进入第二关，角色初始化朝向为上。

#figurex("./assets/play-6.jpg", "第二关", width: 70%)

初始化为关卡显示为 2，得分显示为 0。

#figurex("./assets/play-7.jpg", "关卡信息显示-3", width: 70%)

随着进一步的游玩，游戏推进到了最后一关第五关，此时已经有些难度了。

#figurex("./assets/play-8.jpg", "第五关", width: 70%)

关卡显示为 5，得分显示为 1。

#figurex("./assets/play-9.jpg", "关卡信息显示-5", width: 70%)

#pagebreak()

= 组内成员及工作说明

// TODO