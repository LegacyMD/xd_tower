extends Node2D

func _should_spawn():
    return randf() <= Settings.EFFECT_SPAWN_CHANCE

func _generate_x_pos(x_beg, x_end):
    var spawn_range = x_end - x_beg
    return randf() * spawn_range + x_beg

func _on_platform_spawner_platform_spawned(view_name, x_beg, x_end, y_position):
    if not _should_spawn():
        return

    # Remove left and right parts of the view so that the frog doesn't get stuck
    # in the wall after a slap effect
    x_beg += Settings.EFFECT_SPAWN_MARGIN
    x_end -= Settings.EFFECT_SPAWN_MARGIN

    var effect = preload("res://scenes/effect.tscn")
    var view = get_node("../%s" % view_name)

    var instance = effect.instantiate()
    instance.position.x = _generate_x_pos(x_beg, x_end)
    instance.position.y = y_position
    instance.name = "Effect_y%d" % [int(y_position)]

    var player = view.find_child("Player")
    player.connect_gathered_signal(instance.effectGathered)
    var enemy = view.the_other_view.find_child("Player")
    enemy.connect_inflict_signal(instance.effectInflicted)
    var container = get_node("../%s/PlatformContainer" % view_name)
    container.add_child(instance)

    var active_effect_icon = get_node("../%s" % view_name)
    active_effect_icon = active_effect_icon.the_other_view
    active_effect_icon = active_effect_icon.get_node("ActiveEffectIcon")

    instance.effectInflicted.connect(active_effect_icon.show_icon)

