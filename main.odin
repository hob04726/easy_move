package main

import rl "vendor:raylib"
import "core:fmt"
import "draw"
import "data"

SCREEN_WIDTH  :: 600
SCREEN_HEIGHT :: 600


main :: proc() {
    rl.SetConfigFlags({.WINDOW_RESIZABLE});
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "easy move!")
    rl.SetWindowMinSize(600, 600)

    rl.SetTargetFPS(240)
    rl.HideCursor()

    draw.load_fonts()
    defer draw.unload_fonts()

    for !rl.WindowShouldClose() {

        rl.BeginDrawing()

        rl.ClearBackground(rl.Color{30, 30, 30, 255})
        rl.DrawFPS(0, 0)

        // @Incompleted: Implement the playground render
        draw.draw_scene(data.scenes_list[data.current_scene_id])

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
