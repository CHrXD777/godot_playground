extends Node2D

@onready var tilemap = $TileMapLayer

func draw_map(world):
    for y in world.height:
        for x in world.width:
            var tile = world.tiles[y][x]
            if tile == 1:
                tilemap.set_cell(Vector2i(x,y), 0 , Vector2i(10,17))
            elif tile == 0:
                tilemap.set_cell(Vector2i(x,y), 0 , Vector2i(19,1))
            
