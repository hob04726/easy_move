package data
import "core:slice"

//
// This is the structure to store the data of a scene.
//
current_scene_id : int = 0

Scene :: struct {
    profile_ground : [][]string,
    profile_blocks : [][]string
}

clone_2d_dynamic :: proc(src: [][] $T) -> [dynamic][dynamic]T {
    grid := make([dynamic][dynamic]T, len(src))
    for row, i in src {
        grid[i] = slice.clone_to_dynamic(row)
    }
    return grid
}

delete_2d_dynamic :: proc(grid: [dynamic][dynamic] $T) {
    for row in grid {
        delete(row)
    }
    delete(grid)
}

switch_to_scene :: proc(scene_id: int){
   current_scene_id = scene_id
}

Runtime_Scene :: struct {
    ground : [dynamic][dynamic]string,
    blocks : [dynamic][dynamic]string
}

runtime_scene : Runtime_Scene

init_scene :: proc(){
    runtime_scene.ground = clone_2d_dynamic(scenes_list[current_scene_id].profile_ground)
    runtime_scene.blocks = clone_2d_dynamic(scenes_list[current_scene_id].profile_blocks)
}

release_scene :: proc(){
    delete_2d_dynamic(runtime_scene.ground)
    delete_2d_dynamic(runtime_scene.blocks)
}

//
// Store the data of the different scene.
//
scenes_list := []Scene {
    hello_page_scene
}

hello_page_scene : Scene = {
    {
        {"0", "Door", "0"},
        {"0", "0", "0"},
        {"0", "0", "0"}
    },
    {
        {"0", "0", "0"},
        {"0", "0", "0"},
        {"0", "Player", "0"}
    }
}
