package draw

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"
import "../data"

@(private)
draw_window_scale : f32 = 0.309
@(private)
normal_font : rl.Font

@(private)
draw_window_length : f32
@(private)
row_length    : int
@(private)
column_length : int

@(private)
grid_step_length  : f32

@(private)
left_offset  : f32
@(private)
above_offset : f32

@(private)
text_size : f32
@(private)
between_margin : f32

set_default_variables :: proc(){
    // @Incompleted: use font to draw the number.
    // normal_font := rl.LoadFont("assets/fonts/OpenSans-Regular.ttf")
    // rl.UnloadFont(normal_font)


    draw_window_length = f32( min(rl.GetScreenWidth(), rl.GetScreenHeight()) ) * draw_window_scale
    row_length = len(data.runtime_scene.ground[0])
    column_length = len(data.runtime_scene.ground)

    grid_step_length = f32(draw_window_length) / f32(max(row_length, column_length)-1)

    left_offset  = (( f32( rl.GetScreenWidth() )  - ( f32( row_length ) - 1 )    * grid_step_length ) / 2)
    above_offset = (( f32( rl.GetScreenHeight() ) - ( f32( column_length ) - 1 ) * grid_step_length ) / 2)

    text_size = f32( min(rl.GetScreenWidth(), rl.GetScreenHeight()) ) * 0.1 * draw_window_scale
    between_margin = 3
}

load_fonts :: proc() {
    normal_font = rl.LoadFont("assets/fonts/OpenSans-Regular.ttf")
}

unload_fonts :: proc() {
    rl.UnloadFont(normal_font)
}

//
// Draw a scene with the scene structure.
//

draw_scene :: proc(){

    set_default_variables()

    //
    // We draw the ground in here.
    //
    grid_position := rl.Vector2{left_offset, above_offset}
    for row in data.runtime_scene.ground {
        for grid in row {
            grid_text := strings.clone_to_cstring(grid, context.temp_allocator)
            switch grid{
            case "Ground":
                rl.DrawTextPro(rl.GetFontDefault(),
                    grid_text,
                    grid_position,
                    rl.Vector2{
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).x / 2,
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).y / 2
                    },
                    0, text_size, between_margin, rl.Color{255, 255, 255,  50})

            case "Door":
                rl.DrawTextPro(rl.GetFontDefault(),
                    grid_text,
                    grid_position,
                    rl.Vector2{
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).x / 2,
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).y / 2
                    },
                    0, text_size, between_margin, rl.Color{255, 255, 255, 255})
            case "Empty":
                rl.DrawTextPro(rl.GetFontDefault(),
                    grid_text,
                    grid_position,
                    rl.Vector2{
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).x / 2,
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).y / 2
                    },
                    0, text_size, between_margin, rl.Color{255, 255, 255,   0})
            }
            grid_position.x += grid_step_length
        }
        grid_position.x = left_offset
        grid_position.y += grid_step_length
    }

    //
    // We draw the blocks in here.
    //
    grid_position = rl.Vector2{left_offset, above_offset}
    for row in data.runtime_scene.blocks {
        for grid in row {
            grid_text := strings.clone_to_cstring(grid, context.temp_allocator)
            switch grid{
            case "Empty":
                rl.DrawTextPro(rl.GetFontDefault(),
                    grid_text,
                    grid_position,
                    rl.Vector2{
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).x / 2,
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).y / 2
                    },
                    0, text_size, between_margin, rl.Color{255, 255, 255,  0})

            case "Player":
                rl.DrawTextPro(rl.GetFontDefault(),
                    grid_text,
                    grid_position,
                    rl.Vector2{
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).x / 2,
                        rl.MeasureTextEx(rl.GetFontDefault(), grid_text, text_size, between_margin).y / 2
                    },
                    0, text_size, between_margin, rl.Color{255, 255, 255, 255})
            }
            grid_position.x += grid_step_length
        }
        grid_position.x = left_offset
        grid_position.y += grid_step_length
    }

    //
    // We draw the edges in here.
    //
    draw_edge()
}


draw_edge :: proc(){

    edge_position_mat := make([dynamic][dynamic]rl.Vector2, len(data.runtime_scene.ground)+1, context.temp_allocator)
    for i in 0..<len(data.runtime_scene.ground)+1{
        edge_position_mat[i] = make([dynamic]rl.Vector2, len(data.runtime_scene.ground[0])+1, context.temp_allocator)
    }

    for row, i in edge_position_mat{
        for &grid, j in row{
            grid = rl.Vector2{left_offset + ( f32(j) - 0.5 ) * grid_step_length, above_offset + ( f32(i) - 0.5 ) * grid_step_length}
        }
    }

    for row, i in data.runtime_scene.ground{
        for grid, j in row{
            if grid != "Empty"{
                if ( ( i > 0 && data.runtime_scene.ground[i-1][j] == "Empty" ) || i == 0  ){
                    rl.DrawLineEx(edge_position_mat[i][j], edge_position_mat[i][j+1], 3, rl.WHITE)
                }
                if ( ( j > 0 && data.runtime_scene.ground[i][j-1] == "Empty" ) || j == 0  ){
                    rl.DrawLineEx(edge_position_mat[i][j], edge_position_mat[i+1][j], 3, rl.WHITE)
                }
                if ( ( j < len(row)-1 && data.runtime_scene.ground[i][j+1] == "Empty" ) || j == len(row)-1  ){
                    rl.DrawLineEx(edge_position_mat[i+1][j+1], edge_position_mat[i][j+1], 3, rl.WHITE)
                }
                if ( ( i < len(data.runtime_scene.ground)-1 && data.runtime_scene.ground[i+1][j] == "Empty" ) || i == len(data.runtime_scene.ground)-1  ){
                    rl.DrawLineEx(edge_position_mat[i+1][j+1], edge_position_mat[i+1][j], 3, rl.WHITE)
                }
            }
        }
    }
}
