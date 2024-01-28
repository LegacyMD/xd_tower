extends Node2D

class_name Effect

signal effectGathered(affected_player_idx : int, effect : Effect.EffectType)
signal effectInflicted(affected_player_idx : int, effect : Effect.EffectType)

enum EffectType {
    None,
    Bounce,
    SmashWithBlock,
    TwistMovingDirections,
    BeingSlapped,
    Slapping
}

func _get_other_player_idx(player_idx: int) -> int:
    return not player_idx

func _pick_random_effect() -> EffectType:
    return (randi() % (EffectType.size() - 1)) as EffectType

func _on_player_entered(body):
    var player_idx = body.player_idx
    var enemy_player_idx = _get_other_player_idx(player_idx)
    print("Player %d gathered effect" % player_idx)

    var effect_type = _pick_random_effect()
    if effect_type == EffectType.BeingSlapped:
        effectGathered.emit(player_idx, EffectType.Slapping)
    else:
        effectGathered.emit(player_idx, EffectType.None)
    effectInflicted.emit(enemy_player_idx, effect_type)
    queue_free() # Remove from the tree
