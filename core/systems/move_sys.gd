extends RefCounted
class_name MoveSystem

func try_move(world, entity, dir_name:String) -> Dictionary:
    var dir = world.DIRS[dir_name]
    return world.move_entity(entity, dir)
