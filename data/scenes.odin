package data
import "core:slice"

//
// This is the structure to store the data of a scene.
//
current_scene_id : int = 0

Vector2i :: struct {
    x : int,
    y : int
}

Scene :: struct {
    profile_ground : [][]string,
    profile_blocks : [][]string
}

Memery_Buffers :: struct{
    current_buffer_id : int,
    memery_scene_blocks : [dynamic][dynamic][dynamic]string,
    memery_scene_ground : [dynamic][dynamic][dynamic]string,
    memery_command : [dynamic]Move_Direction
}

Move_Direction :: enum{
    LEFT,
    RIGHT,
    UP,
    DOWN,
    NONE
}

current_memery_buffers : Memery_Buffers

clone_2d_dynamic :: proc(src: [][] $T) -> [dynamic][dynamic]T {
    grid := make([dynamic][dynamic]T, len(src))
    for row, i in src {
        grid[i] = slice.clone_to_dynamic(row)
    }
    return grid
}

clone_2d_from_dynamic :: proc(
    src: [dynamic][dynamic]$T,
) -> [dynamic][dynamic]T {
    result := make([dynamic][dynamic]T, len(src))

    for row, i in src {
        result[i] = slice.clone_to_dynamic(row[:])
    }

    return result
}

delete_2d_dynamic :: proc(grid: [dynamic][dynamic] $T) {
    for row in grid {
        delete(row)
    }
    delete(grid)
}

switch_to_scene :: proc(scene_id: int){
    current_scene_id = scene_id
    release_scene()
    init_scene()
}

Runtime_Scene :: struct {
    ground : [dynamic][dynamic]string,
    blocks : [dynamic][dynamic]string
}

runtime_scene : Runtime_Scene

init_scene :: proc(){
    runtime_scene.ground = clone_2d_dynamic(scenes_list[current_scene_id].profile_ground)
    runtime_scene.blocks = clone_2d_dynamic(scenes_list[current_scene_id].profile_blocks)
    append(&current_memery_buffers.memery_scene_blocks, clone_2d_from_dynamic(runtime_scene.blocks))
    append(&current_memery_buffers.memery_scene_ground, clone_2d_from_dynamic(runtime_scene.ground))
    current_memery_buffers.current_buffer_id = 0
    append(&current_memery_buffers.memery_command, Move_Direction.NONE)
}

release_scene :: proc(){
    delete_2d_dynamic(runtime_scene.ground)
    delete_2d_dynamic(runtime_scene.blocks)
    for buffer in current_memery_buffers.memery_scene_blocks{
        delete_2d_dynamic(buffer)
    }
    for buffer in current_memery_buffers.memery_scene_ground{
        delete_2d_dynamic(buffer)
    }
}

//
// Store the data of the different scene.
//
scenes_list := []Scene {
    hello_page_scene
}

hello_page_scene : Scene = {
    {
        {"Ground", "Door"  , "Ground"},
        {"Ground", "Ground", "Ground"},
        {"Ground", "Ground", "Empty" }
    },
    {
        {"Player", "Empty" , "Empty" },
        {"Empty" , "Empty" , "Empty" },
        {"Empty" , "Player", "Empty" }
    }
}
