extends Node
@export var grid_size: Vector2i = Vector2i(16, 16)
@export var grid_offset: Vector2i = Vector2i(10, 10)
@export var cell_size: int = 16

func grid2px(grid_coord: Vector2i)-> Vector2i:
    var px_coord: Vector2i = Vector2i.ZERO
    px_coord.x = grid_coord.x * cell_size + grid_offset.x
    px_coord.y = grid_coord.y * cell_size + grid_offset.y
    return px_coord
    
func px2grid(px_coord: Vector2i) -> Vector2i:
    var grid_coord: Vector2i = Vector2i.ZERO
    grid_coord.x = (px_coord.x-grid_offset.x) / cell_size
    grid_coord.y = (px_coord.y-grid_offset.y) / cell_size
    return grid_coord

        
    
