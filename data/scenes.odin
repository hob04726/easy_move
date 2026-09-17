package data

//
// This is the structure to store the data of a scene.
//

Scene :: struct {
    ground : [][]int,
    blocks : [][]int
}



//
// Store the data of the different scene.
//

hello_page_scene : Scene = {
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
}
