package main

import rl "vendor:raylib"

import "core:fmt"
import "draw"

SCREEN_WIDTH  :: 600
SCREEN_HEIGHT :: 600

main :: proc() {
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "easy move!")

    for !rl.WindowShouldClose() {
        fmt.println("running")


        rl.BeginDrawing()
        // @Incompleted: Implement the playground render
        draw.draw_ground()

        rl.ClearBackground(rl.Color{255, 250, 240, 255})
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
