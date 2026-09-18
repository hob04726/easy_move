package data
import "core:slice"

//
// This is the structure to store the data of a scene.
//
current_scene_id : int = 0

Scene :: struct {
    ground : [][]string,
    blocks : [][]string
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
    main.current_scene_id = scene_id
}

//
// Store the data of the different scene.
//
scenes_list := []Scene {
    hello_page_scene
}

hello_page_scene : Scene = {
    {{"0", "0", "0"}, {"0", "0", "0"}, {"0", "0", "0"}},
    {{"0", "0", "0"}, {"0", "0", "0"}, {"0", "0", "0"}}
}
