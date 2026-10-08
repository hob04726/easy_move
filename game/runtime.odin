package game

import rl "vendor:raylib"
import "../data"
import "core:fmt"
import "core:math"

update :: proc(dt: f32){
    switch{
    case rl.IsKeyPressed(.LEFT):
        fmt.println("move to left")
        get_all_movable_blocks(.LEFT)
    case rl.IsKeyPressed(.RIGHT):
        fmt.println("move to right")
        get_all_movable_blocks(.RIGHT)
    case rl.IsKeyPressed(.UP):
        fmt.println("move to up")
        get_all_movable_blocks(.UP)
    case rl.IsKeyPressed(.DOWN):
        fmt.println("move to down")
        get_all_movable_blocks(.DOWN)
    case rl.IsKeyPressed(.A):
        fmt.println("move to left")
        get_all_movable_blocks(.LEFT)
    case rl.IsKeyPressed(.D):
        fmt.println("move to right")
        get_all_movable_blocks(.RIGHT)
    case rl.IsKeyPressed(.W):
        fmt.println("move to up")
        get_all_movable_blocks(.UP)
    case rl.IsKeyPressed(.S):
        fmt.println("move to down")
        get_all_movable_blocks(.DOWN)
    case rl.IsKeyPressed(.U):
        fmt.println("Undo")
        //@Incompleted: We need to take the memery buffer out here.
    case rl.IsKeyPressed(.R):
        fmt.println("Redo")
        //@Incompleted: We need to take the scene out here.
        }
    }

is_in_bounds :: proc(grid: [dynamic][dynamic] $T, r: int, c: int) -> bool {
    if r < 0 || r >= len(grid) do return false
    if c < 0 || c >= len(grid[r]) do return false
    return true
}

get_all_movable_blocks :: proc(move_direction: data.Move_Direction){
    #partial switch move_direction{
    case .LEFT:
        for raw, i in data.runtime_scene.blocks{
            for grid, j in raw{
                if grid == "Player"{

                    if is_in_bounds(data.runtime_scene.blocks, i, j-1) &&
                    data.runtime_scene.ground[i][j-1] == "Ground" &&
                    data.runtime_scene.blocks[i][j-1] == "Empty"{
                        try_move_block(data.Vector2i{i, j}, data.Vector2i{ 0, -1})
                    }
                }
            }
        }
    case .RIGHT:
        for raw, i in data.runtime_scene.blocks{
            #reverse for grid, j in raw{
                if grid == "Player"{
                    if is_in_bounds(data.runtime_scene.blocks, i, j+1) &&
                    data.runtime_scene.ground[i][j+1] == "Ground" &&
                    data.runtime_scene.blocks[i][j+1] == "Empty"{
                        try_move_block(data.Vector2i{i, j}, data.Vector2i{ 0,  1})
                    }
                }
            }
        }
    case .UP:
        for raw, i in data.runtime_scene.blocks{
            for grid, j in raw{
                if grid == "Player"{
                    if is_in_bounds(data.runtime_scene.blocks, i-1, j) &&
                    data.runtime_scene.ground[i-1][j] == "Ground" &&
                    data.runtime_scene.blocks[i-1][j] == "Empty"{
                        try_move_block(data.Vector2i{i, j}, data.Vector2i{-1,  0})
                    }
                }
            }
        }
    case .DOWN:
        #reverse for raw, i in data.runtime_scene.blocks{
            for grid, j in raw{
                if grid == "Player"{
                    if is_in_bounds(data.runtime_scene.blocks, i+1, j) &&
                    data.runtime_scene.ground[i+1][j] == "Ground" &&
                    data.runtime_scene.blocks[i+1][j] == "Empty"{
                        try_move_block(data.Vector2i{i, j}, data.Vector2i{ 1,  0})
                    }
                }
            }
        }
    case .NONE:
        // @Incompleted: other class to choose in here.
    }
    append(
        &data.memery_buffer_list, data.Memery_Buffer{
            buffer_id = data.current_memery_buffer_id + 1,
            memery_scene_blocks = data.clone_2d_from_dynamic(data.runtime_scene.blocks),
            memery_scene_ground = data.clone_2d_from_dynamic(data.runtime_scene.ground),
            move_command = data.Move_Direction.NONE,
        }
    )
}

do_one_move :: proc(position: data.Vector2i, target_position: data.Vector2i, is_block: bool){
    // @Incopleted: the logic to move Ground is waiting.
    if is_block{
        data.runtime_scene.blocks[target_position.x][target_position.y] = data.runtime_scene.blocks[position.x][position.y]
        data.runtime_scene.blocks[position.x][position.y] = "Empty"
    }
}

try_move_block :: proc(
    position: data.Vector2i,
    move_direction: data.Vector2i // This variable can only be inputed by one direction.
){
    move_in_v : bool = move_direction.y != 0
    move_positive : bool = max(move_direction.x, move_direction.y) != 0
    // @Incopleted: other logic to move is waiting.
    switch data.runtime_scene.blocks[position.x][position.y]{
    case "Player":
        for i := 0; i < max(math.abs(move_direction.x), math.abs(move_direction.y)); i += 1{
            if move_in_v{
                if move_positive{
                    target_position : data.Vector2i = {position.x, position.y+1}
                    do_one_move(position, target_position, true)
                }else{
                    target_position : data.Vector2i = {position.x, position.y-1}
                    do_one_move(position, target_position, true)
                }
            }else{
                if move_positive{
                    target_position : data.Vector2i = {position.x+1, position.y}
                    do_one_move(position, target_position, true)
                }else{
                    target_position : data.Vector2i = {position.x-1, position.y}
                    do_one_move(position, target_position, true)
                }
            }
        }
    }
}




// update_all_movable_blocks :: proc(move_direction: data.Move_Direction){
//     #partial switch move_direction{
//     case .LEFT:
//         for grid_position in movable_blocks{
//             try_move_block(grid_position, data.Vector2i{ 0, -1})
//         }
//     case .RIGHT:
//         for grid_position in movable_blocks{
//             try_move_block(grid_position, data.Vector2i{ 0,  1})
//         }
//     case .UP:
//         for grid_position in movable_blocks{
//             try_move_block(grid_position, data.Vector2i{-1,  0})
//         }
//     case .DOWN:
//         for grid_position in movable_blocks{
//             try_move_block(grid_position, data.Vector2i{ 1,  0})
//         }
//     }
// }
