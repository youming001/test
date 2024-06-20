#import "@preview/tablex:0.0.8": tablex, colspanx, rowspanx, hlinex, vlinex, cellx
#import "@preview/showybox:2.0.1": showybox

#let state_course = state("course", none)
#let state_author = state("author", none)
#let state_school_id = state("school_id", none)
#let state_date = state("date", none)
#let state_major = state("major", none)
#let state_teacher = state("teacher", none)

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

#let project(
    course: "<course>",
    title: "<title>",
    author: none,
    college: none,
    department: none,
    major: none,
    school_id: none,
    teacher: none,
    date: datetime.today().display("[year]年[month]月[day]日"),
    font_serif: ("New Computer Modern", "Georgia", "Nimbus Roman No9 L", "Songti SC", "Noto Serif CJK SC", "Source Han Serif SC", "Source Han Serif CN", "STSong", "AR PL New Sung", "AR PL SungtiL GB", "NSimSun", "SimSun", "TW\-Sung", "WenQuanYi Bitmap Song", "AR PL UMing CN", "AR PL UMing HK", "AR PL UMing TW", "AR PL UMing TW MBE", "PMingLiU", "MingLiU"),
    font_sans_serif: ("Noto Sans", "Helvetica Neue", "Helvetica", "Nimbus Sans L", "Arial", "Liberation Sans", "PingFang SC", "Hiragino Sans GB", "Noto Sans CJK SC", "Source Han Sans SC", "Source Han Sans CN", "Microsoft YaHei", "Wenquanyi Micro Hei", "WenQuanYi Zen Hei", "ST Heiti", "SimHei", "WenQuanYi Zen Hei Sharp"),
    font_mono: ("Consolas", "Monaco"),
    body
) = {
    set document(author: (author), title: title)
    set page(numbering: "1", number-align: center)
    set text(font: font_serif, lang: "cn", size: 12pt)
    set par(leading: 1.2em, justify: true)

    show raw: set text(font: (..font_mono, ..font_sans_serif))
    show math.equation: set text(weight: 400)
    show par: set block(above: 1.2em, below: 1.2em)
    show heading: pad.with(top: .6em, bottom: .6em)

    state_course.update(course)
    state_author.update(author)
    state_school_id.update(school_id)
    state_date.update(date)
    state_major.update(major)
    state_teacher.update(teacher)

    v(1fr)
    align(center, image("./assets/ZJU-Banner.png", width: 48%))
    v(2em)
    align(center)[
        #set text(size: 20pt)
        *本科实验报告*
    ]
    v(2fr)
    align(center, box(width: 75%)[
        #set text(size: 1.2em)  
        #tablex(
            columns: (6.5em + 5pt, 1fr),
            align: center + horizon,
            stroke: 0pt,
            inset: 1pt,
            map-cells: cell => {
                if (cell.x == 0) {
                    underlined_cell([#cell.content#"："], color: white)
                } else {
                    underlined_cell(cell.content, color: black)
                }
            },
            [课程名称], course,
            [姓　　名], author,
            [学　　院], college,
            [　　　系], department,
            [专　　业], major,
            [学　　号], school_id,
            [指导教师], teacher,
        )
    ])
    v(.8fr)
    align(center)[
        #set text(size: 1.2em)
        #v(1em)
        #date
    ]
    v(1fr)
    pagebreak()

    set heading(numbering: (..args) => {
        let nums = args.pos()
        if nums.len() == 1 { return none }
        else if nums.len() == 2 { return numbering("1 ", nums.at(1)) }
        else { return numbering("1.i ", nums.at(1), nums.at(2)) }
    })
    set table(align: center + horizon, stroke: 0.5pt)
    set enum(indent: .5em)
    set list(indent: .5em)
    show enum: pad.with(y: .8em)

    body
}

#let codex(src, lang: none) = {
    let code = read(src)
    if code.ends-with("\n") {
        code = code.slice(0, code.len() - 1)
    }
    align(left)[
        #block(
            width: 100%,
            stroke: 0.5pt + luma(150),
            radius: 4pt,
            inset: 8pt,
        )[ #raw(lang: lang, block: true, code) ]
    ]
}

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
        supplement: [Fig.],
        caption: if caption == "" {none} else {text(weight: 400, caption)}
    )
}
