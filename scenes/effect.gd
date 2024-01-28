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

var effect_type : EffectType

func _ready():
    effect_type = _pick_random_effect()
    match effect_type:
        EffectType.Bounce:
            $AnimatedSprite2D.frame = 1
        EffectType.SmashWithBlock:
            $AnimatedSprite2D.frame = 0
        EffectType.TwistMovingDirections:
            $AnimatedSprite2D.frame = 2
        EffectType.Slapping, EffectType.BeingSlapped:
            $AnimatedSprite2D.frame = 3

   # $AnimatedSprite2D.frame = effect_type * 1 # to cast enum to int I cannot use casting, but I can multiply by 1. WTF XD

func _process(_delta):
    if global_position.y > 1200:
        queue_free()

func _get_other_player_idx(player_idx: int) -> int:
    return not player_idx

func _pick_random_effect() -> EffectType:
    return ((randi() % (EffectType.size() - 2)) + 1) as EffectType

func _on_player_entered(body):
    var player_idx = body.player_idx
    var enemy_player_idx = _get_other_player_idx(player_idx)
    print("Player %d gathered effect %s" % [player_idx, str(effect_type)])

    if effect_type == EffectType.BeingSlapped:
        effectGathered.emit(player_idx, EffectType.Slapping)
    else:
        effectGathered.emit(player_idx, EffectType.None)
    effectInflicted.emit(enemy_player_idx, effect_type)
    queue_free() # Remove from the tree
