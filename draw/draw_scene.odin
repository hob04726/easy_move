package draw

import rl "vendor:raylib"

import "../data"


//
// Draw a scene with the scene structure.
//

draw_scene :: proc(scene: data.Scene){

    ground : [dynamic][dynamic]int
    blocks : [dynamic][dynamic]int

    for row in scene.ground {
        new_row : [dynamic]int
        append(&new_row, ..row)
        append(&ground , new_row)
    }

    for row in scene.blocks {
        new_row: [dynamic]int
        append(&new_row, ..row)
        append(&blocks , new_row)
    }

    defer {
        for row in ground {
            delete(row)
        }
        delete(ground)

        for row in blocks {
            delete(row)
        }
        delete(blocks)
    }

    // @Incompleted: use font to draw the number.
    // normal_font := rl.LoadFont("assets/fonts/OpenSans-Regular.ttf")
    // rl.UnloadFont(normal_font)





}

