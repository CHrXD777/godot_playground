extends RefCounted
class_name InteractionSystem

signal npc_dialogue(npc)
signal enemy_battle(enemy)

func process_bump(entity, target):
    if target.kind == "npc":
        emit_signal("npc_dialogue", target)
    elif target.kind == "enemy":
        emit_signal("enemy_battle", target)
