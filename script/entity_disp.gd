extends Node2D
class_name EntityDisplay

var entity

func _ready() -> void:
    $Sprite2D.region_enabled = true
    $Sprite2D.region_rect = entity.sprite

func update_display():
    position = (entity.pos * 16)+Vector2i(8,8)
