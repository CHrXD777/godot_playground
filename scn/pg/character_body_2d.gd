extends CharacterBody2D

@export var cell_size = 16
@export var move_speed = 8.0  # 数值越大移动越快

var target_pos: Vector2
var moving := false

func _ready():
    target_pos = position

func _physics_process(delta):
    if moving:
        # 平滑移动到目标格
        position = position.move_toward(target_pos, move_speed)
        if position == target_pos:
            moving = false
        return

    # 不在移动时，监听输入
    var dir = Vector2.ZERO
    if Input.is_action_just_pressed("move_left"):
        dir = Vector2.LEFT
    elif Input.is_action_just_pressed("move_right"):
        dir = Vector2.RIGHT
    elif Input.is_action_just_pressed("move_up"):
        dir = Vector2.UP
    elif Input.is_action_just_pressed("move_down"):
        dir = Vector2.DOWN

    if dir != Vector2.ZERO:
        var next_pos = target_pos + dir * cell_size

        # 🔍 碰撞检测：尝试移动
        var collision = move_and_collide(dir * cell_size)
        if collision:
            # 有碰撞 -> 不移动，复原位置
            position = target_pos
        else:
            # 没碰撞 -> 确认目标格
            position = target_pos  # 复原以防 move_and_collide 修改
            target_pos = next_pos
            moving = true
