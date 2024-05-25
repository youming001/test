DISPLAY: 640px * 480px 60Hz

LEVEL: 10 * 10 ASCII

BLOCK: 48px * 48px

```c
const MAP levels[]

TOP() {
    init VGA;
    
}

LEVEL_SELECTOR(int level) {
    return raw_levels[level];
}

GAME_LOGIC(DATA raw_data) {
    bg_data, char_data, char_pos[] = raw_data;
    always FRAME_RENDERER(bg_data, char_data, char_pos);

    if (on animation) {
        update char_pos;
    }

    if (wsad) {
        ...
    } else if (restart) {
        ...
    }
}

FRAME_RENDERER(MAP bg_data, MAP char_data, MAP_PX char_pos[]) {
    BG_RENDERER(bg_data);
    CHAR_RENDERER(char_pos);
}

CHAR_RENDERER(MAP_PX char_pos[]) {
    // char_pos[0] => player position in pixels
    // etc.
    for (char_pos)
        IMG_RENDERER(char_pos[i], (x, y));
}

BG_RENDERER(MAP bg_data) {
    for (bg_data) {
        IMG_RENDERER(bg_data[i][j], (x, y));
    }
}

IMG_RENDERER(TYPE image_type, PIXEL pos) {
    VRAM.rgb at pos = IMG_SELECTOR(image_type);
}

IMG_SELECTOR(TYPE image_type) {
    return BYTE image_data[][];
}

VRAM() {
    BYTE rgb[][][];
    display(rgb);
}
```