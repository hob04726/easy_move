package game

import rl "vendor:raylib"
import "../data"
import "core:fmt"
import "core:math"

movable_blocks : [dynamic]data.Vector2i

Move_Direciton :: enum{
    LEFT,
    RIGHT,
    UP,
    DOWN,
}

update :: proc(dt: f32){
    switch{
    case rl.IsKeyPressed(.LEFT ):
        fmt.println("move to left")
        get_all_movable_blocks(.LEFT)
        update_all_movable_blocks(.LEFT)
    case rl.IsKeyPressed(.RIGHT):
        fmt.println("move to right")
        get_all_movable_blocks(.RIGHT)
        update_all_movable_blocks(.RIGHT)
    case rl.IsKeyPressed(.UP   ):
        fmt.println("move to up")
        get_all_movable_blocks(.UP)
        update_all_movable_blocks(.UP)
    case rl.IsKeyPressed(.DOWN ):
        fmt.println("move to down")
        get_all_movable_blocks(.DOWN)
        update_all_movable_blocks(.DOWN)
        }


    }

is_in_bounds :: proc(grid: [dynamic][dynamic] $T, r: int, c: int) -> bool {
    if r < 0 || r >= len(grid) do return false
    if c < 0 || c >= len(grid[r]) do return false
    return true
}

get_all_movable_blocks :: proc(move_direction: Move_Direciton){
    clear(&movable_blocks)
    for raw, i in data.runtime_scene.blocks{
        for grid, j in raw{
            if grid == "Player"{
                switch move_direction{
                case .LEFT:
                    if is_in_bounds(data.runtime_scene.blocks, i, j-1) &&
                    data.runtime_scene.ground[i][j-1] == "Ground" &&
                    data.runtime_scene.blocks[i][j-1] == "Empty"{
                        append(&movable_blocks, data.Vector2i{i, j})
                    }
                case .RIGHT:
                    if is_in_bounds(data.runtime_scene.blocks, i, j+1) &&
                    data.runtime_scene.ground[i][j+1] == "Ground" &&
                    data.runtime_scene.blocks[i][j+1] == "Empty"{
                        append(&movable_blocks, data.Vector2i{i, j})
                    }
                case .UP:
                    if is_in_bounds(data.runtime_scene.blocks, i-1, j) &&
                    data.runtime_scene.ground[i-1][j] == "Ground" &&
                    data.runtime_scene.blocks[i-1][j] == "Empty"{
                        append(&movable_blocks, data.Vector2i{i, j})
                    }
                case .DOWN:
                    if is_in_bounds(data.runtime_scene.blocks, i+1, j) &&
                    data.runtime_scene.ground[i+1][j] == "Ground" &&
                    data.runtime_scene.blocks[i+1][j] == "Empty"{
                        append(&movable_blocks, data.Vector2i{i, j})
                    }
                }
            }
            // @Incompleted: other class to choose in here.
        }
    }
    for position in movable_blocks{
        fmt.println("x=", position.x, "y=", position.y)
    }
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




update_all_movable_blocks :: proc(move_direction: Move_Direciton){
    switch move_direction{
    case .LEFT:
        for grid_position in movable_blocks{
            try_move_block(grid_position, data.Vector2i{ 0, -1})
        }
    case .RIGHT:
        for grid_position in movable_blocks{
            try_move_block(grid_position, data.Vector2i{ 0,  1})
        }
    case .UP:
        for grid_position in movable_blocks{
            try_move_block(grid_position, data.Vector2i{-1,  0})
        }
    case .DOWN:
        for grid_position in movable_blocks{
            try_move_block(grid_position, data.Vector2i{ 1,  0})
        }
    }
}
