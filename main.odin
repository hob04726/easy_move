package main

import rl "vendor:raylib"

import "core:fmt"
import "draw"
import "data"

SCREEN_WIDTH  :: 600
SCREEN_HEIGHT :: 600

main :: proc() {
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "easy move!")

    rl.SetTargetFPS(240)

    for !rl.WindowShouldClose() {

        rl.BeginDrawing()

        rl.ClearBackground(rl.Color{30, 30, 30, 255})
        rl.DrawFPS(0, 0)

        // @Incompleted: Implement the playground render
        draw.draw_scene(data.hello_page_scene)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
