# res://core/entity.gd
extends RefCounted
class_name Player

var id = ""
var name = ""
var pos: Vector2i = Vector2i.ZERO
var kind = ""   # "player","npc","enemy"
var hp = 10
var sprite = Rect2()

func load_from_data(data: Dictionary) -> void:
    # 基本字段（存在则读取，不存在则保留默认）
    if data.has("id"):
        id = data.id
    if data.has("name"):
        name = data.name
    if data.has("kind"):
        kind = data.kind
    if data.has("hp"):
        hp = int(data.hp)

    # pos 可能在类型定义里也可能在实例化时由外部赋值
    if data.has("pos"):
        # 允许 pos 以数组或 Vector2i 表示
        var p = data.pos
        if typeof(p) == TYPE_ARRAY and p.size() >= 2:
            pos = Vector2i(int(p[0]), int(p[1]))
        elif typeof(p) == TYPE_VECTOR2:
            pos = Vector2i(int(p.x), int(p.y))
        elif typeof(p) == TYPE_VECTOR2I:
            pos = p
        # 否则保留默认 pos（通常由外部赋值）
