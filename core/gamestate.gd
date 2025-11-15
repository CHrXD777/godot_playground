extends Node2D

var world: World
var move_system: MoveSystem
var interaction_system: InteractionSystem
var battle_system: BattleSystem

@onready var grid_disp = $Grid
@onready var entity_disp = $EntitiesRoot


func _ready():
    # 初始化世界
    world = World.new()

    # 载入地图
    var map_data = JSON.parse_string(
        FileAccess.get_file_as_string("res://data/town_map.json")
    )
    world.load_map(map_data)
    
    var player_defs = JSON.parse_string(
        FileAccess.get_file_as_string("res://data/player_def.json")
    )
    var player_sprite = Rect2(player_defs["player"]["sprite"][0], player_defs["player"]["sprite"][1], 
            player_defs["player"]["sprite"][2], player_defs["player"]["sprite"][3],)
    
    var entity_defs = JSON.parse_string(
        FileAccess.get_file_as_string("res://data/entity_def.json")
    )
    var npc_sprite = Rect2(entity_defs["npc_villager"]["sprite"][0], entity_defs["npc_villager"]["sprite"][1], 
            entity_defs["npc_villager"]["sprite"][2], entity_defs["npc_villager"]["sprite"][3],)
    var enemy_sprite = Rect2(entity_defs["enemy_slime"]["sprite"][0], entity_defs["enemy_slime"]["sprite"][1], 
            entity_defs["enemy_slime"]["sprite"][2], entity_defs["enemy_slime"]["sprite"][3],)
    
    # 创建玩家
    var p = Player.new()
    p.load_from_data(player_defs["player"])
    p.pos = Vector2i(2,2)
    p.sprite = player_sprite
    world.add_entity(p)
    player_display(p)
    
    # 创建NPC
    var npc = Entity.new()
    npc.load_from_data(entity_defs["npc_villager"])
    npc.pos = Vector2i(3,2)
    npc.sprite = npc_sprite
    world.add_entity(npc)
    entities_display(npc)

    # 创建敌人
    var slime = Entity.new()
    slime.load_from_data(entity_defs["enemy_slime"])
    slime.pos = Vector2i(4,4)
    slime.sprite = enemy_sprite
    world.add_entity(slime)
    entities_display(slime)
    
    # 系统
    move_system = MoveSystem.new()
    interaction_system = InteractionSystem.new()
    battle_system = BattleSystem.new()
    # 信号连接
    interaction_system.npc_dialogue.connect(_on_npc_dialogue)
    interaction_system.enemy_battle.connect(_on_enemy_battle)
    battle_system.battle_log.connect(_on_battle_log)
    
    grid_disp.draw_map(world)
    
func entities_display(entity):
    var e = preload("res://scene/Entity_cntr.tscn").instantiate()
    e.entity = entity
    entity_disp.add_child(e)
    e.update_display()

func player_display(entity):
    var e = preload("res://scene/Player_cntr.tscn").instantiate()
    e.entity = entity
    entity_disp.add_child(e)
    e.update_display()
    
func _process(_delta):
    if Input.is_action_just_pressed("move_up"):
        _player_try_move("up")
    if Input.is_action_just_pressed("move_down"):
        _player_try_move("down")
    if Input.is_action_just_pressed("move_left"):
        _player_try_move("left")
    if Input.is_action_just_pressed("move_right"):
        _player_try_move("right")
        
func _player_try_move(dir):
    var result = move_system.try_move(world, world.player, dir)

    match result.type:
        "move":
            update_entities()
        "bump":
            interaction_system.process_bump(world.player, result.target)

func update_entities():
    for e in entity_disp.get_children():
        e.update_display()
        
func _on_npc_dialogue(npc):
    print("和 NPC 对话：", npc.name)

func _on_enemy_battle(enemy):
    print("进入战斗！ 敌人：", enemy.name)
    battle_system.attack(world.player, enemy)

func _on_battle_log(msg):
    print(msg)
