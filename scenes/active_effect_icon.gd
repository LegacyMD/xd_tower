extends AnimatedSprite2D

func _ready():
    visible = false

func show_icon(enemy_player_idx, effect_type : Effect.EffectType):
    visible = true

    match effect_type:
        Effect.EffectType.Bounce:
            $Timer.wait_time = 1.1
            frame = 1
        Effect.EffectType.SmashWithBlock:
            $Timer.wait_time = 3
            frame = 0
        Effect.EffectType.TwistMovingDirections:
            $Timer.wait_time = 5
            frame = 3
        Effect.EffectType.Slapping, Effect.EffectType.BeingSlapped:
            $Timer.wait_time = 5
            frame = 2

    $AnimationPlayer.play("flicker")
    $Timer.start()


func _on_timer_timeout():
    $AnimationPlayer.stop()
    visible = false
