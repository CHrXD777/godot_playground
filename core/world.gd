extends RefCounted

class_name World

const DIRS = {
    "up": Vector2i(0,-1),
    "down": Vector2i(0,1),
    "left": Vector2i(-1,0),
    "right": Vector2i(1,0)
}

var width: int
var height: int
var tiles = []          # 地图格子：0=地板,1=墙
var entities = []       # 所有实体列表（实体对象）
var entity_map = {}     # pos -> entity (加速碰撞与交互)
var player              # 指向玩家实体

func load_map(data: Dictionary):
    width = data.width
    height = data.height
    tiles = data.tiles

func add_entity(entity):
    entities.append(entity)
    entity_map[entity.pos] = entity
    if entity.id == "player":
        player = entity

func is_walkable(pos: Vector2i) -> bool:
    if pos.x < 0 or pos.x >= width:
        return false
    if pos.y < 0 or pos.y >= height:
        return false
    if tiles[pos.y][pos.x] == 1:
        return false
    return true

func get_entity(pos: Vector2i):
    if pos in entity_map:
        return entity_map[pos]
    return null

func move_entity(entity, dir: Vector2i) -> Dictionary:
    var target = entity.pos + dir

    # 1. 地形不可走
    if not is_walkable(target):
        print("blocked！")
        return {"type":"blocked"}

    # 2. 格子里有实体
    var other = get_entity(target)
    if other:
        print("other！")
        return {"type":"bump", "target":other}

    # 3. 真实移动
    entity_map.erase(entity.pos)
    entity.pos = target
    entity_map[target] = entity
    print("move！")

    return {"type":"move","pos":target}
