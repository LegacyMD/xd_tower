extends Node2D

class_name Effect

signal effectGathered(affected_player_idx : int)
signal effectInflicted(affected_player_idx : int, effect : Effect.EffectType)

enum EffectType {
    None,
    Bounce,
    SmashWithBlock,
    TwistMovingDirections
}

func _get_other_player_idx(player_idx: int) -> int:
    return not player_idx

func _on_player_entered(body):
    var player_idx = body.player_idx
    var enemy_player_idx = _get_other_player_idx(player_idx)
    print("Player %d gathered effect" % player_idx)
    
    print(effectGathered.get_connections())
    print(effectInflicted.get_connections())

    var effect_type = EffectType.keys()[randi() % EffectType.size()]
    effectGathered.emit(player_idx)
    print(effectInflicted.get_connections())
    effectInflicted.emit(enemy_player_idx, effect_type)
    print(effectInflicted.get_connections())
    queue_free() # Remove from the tree
