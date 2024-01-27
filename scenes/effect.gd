extends Node2D

class_name Effect

signal effect_gathered(effect_type)

enum EffectType {
    None,
    Bounce,
    SmashWithBlock,
    TwistMovingDirections
}

func _on_player_entered(body):
    print("Player %s gathered effect" % body.name)

    var effect_type = EffectType.keys()[randi() % EffectType.size()]
    effect_gathered.emit(effect_type)
    queue_free() # Remove from the tree
