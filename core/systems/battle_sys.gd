extends RefCounted
class_name BattleSystem

signal battle_log(msg)

func attack(attacker, defender):
    defender.hp -= 3
    emit_signal("battle_log", "%s 攻击 %s 造成 3 点伤害" % [attacker.name, defender.name])

    if defender.hp <= 0:
        emit_signal("battle_log", "%s 被击败！" % defender.name)
        return true
    return false
