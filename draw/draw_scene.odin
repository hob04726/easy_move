package draw

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"
import "../data"

draw_window_scale : f32 = 0.618
normal_font : rl.Font

load_fonts :: proc() {
    normal_font = rl.LoadFont("assets/fonts/OpenSans-Regular.ttf")
}

unload_fonts :: proc() {
    rl.UnloadFont(normal_font)
}

//
// Draw a scene with the scene structure.
//

draw_scene :: proc(scene: data.Scene){

    ground := data.clone_2d_dynamic(scene.ground)
    defer data.delete_2d_dynamic(ground)

    blocks := data.clone_2d_dynamic(scene.blocks)
    defer data.delete_2d_dynamic(blocks)


    // @Incompleted: use font to draw the number.
    // normal_font := rl.LoadFont("assets/fonts/OpenSans-Regular.ttf")
    // rl.UnloadFont(normal_font)


    draw_window_length := f32( min(rl.GetScreenWidth(), rl.GetScreenHeight()) ) * draw_window_scale
    row_length    : int = len(ground[0])
    column_length : int = len(ground)

    grid_step_length  : f32 = f32(draw_window_length) / f32(max(row_length, column_length)-1)

    left_offset  := (( f32( rl.GetScreenWidth() )  - ( f32( row_length ) - 1 )    * grid_step_length ) / 2)
    above_offset := (( f32( rl.GetScreenHeight() ) - ( f32( column_length ) - 1 ) * grid_step_length ) / 2)

    grid_position := rl.Vector2{left_offset, above_offset}
    text_size : f32 = f32( min(rl.GetScreenWidth(), rl.GetScreenHeight()) ) * 0.1 * draw_window_scale
    for row in ground {
        for grid in row {
            grid_text := strings.clone_to_cstring(grid, context.temp_allocator)
            rl.DrawTextPro(rl.GetFontDefault(),
                grid_text,
                grid_position,
                rl.Vector2{
                    rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, 0).x / 2,
                    rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, 0).y / 2
                },
                0, text_size, 0, rl.WHITE)
            grid_position.x += grid_step_length
        }
        grid_position.x = left_offset
        grid_position.y += grid_step_length
    }
}

