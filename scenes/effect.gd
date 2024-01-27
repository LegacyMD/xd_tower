extends Node2D

signal effect_gathered(effect_type)

enum EffectType {
    Bounce,
    SmashWithBlock,
}

func _on_player_entered(body):
    print("Player gathered effect")

    var effect_type = EffectType.keys()[randi() % EffectType.size()]
    effect_gathered.emit(effect_type)
