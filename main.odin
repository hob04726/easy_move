package main

import rl "vendor:raylib"
import "core:fmt"
import "draw"
import "game"
import "data"

SCREEN_WIDTH  :: 600
SCREEN_HEIGHT :: 600


main :: proc() {
    rl.SetConfigFlags({.WINDOW_RESIZABLE});
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "easy move!")
    rl.SetWindowMinSize(600, 600)

    rl.SetTargetFPS(60)
    // rl.HideCursor()

    draw.load_fonts()
    defer draw.unload_fonts()


    data.init_scene()

    for !rl.WindowShouldClose() {

        rl.BeginDrawing()

        rl.ClearBackground(rl.Color{30, 30, 30, 255})
        rl.DrawFPS(0, 0)

        // @Incompleted: Implement the logic of the game.
        game.update(rl.GetFrameTime())

        // @Incompleted: Implement the playground render.
        draw.draw_scene()

        rl.EndDrawing()
    }

    data.release_scene()

    rl.CloseWindow()
}
