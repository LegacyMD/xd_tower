extends Node2D

func _should_spawn():
    return randf() <= Settings.EFFECT_SPAWN_CHANCE

func _generate_x_pos(x_beg, x_end):
    var spawn_range = x_end - x_beg
    return randf() * spawn_range + x_beg

func _on_platform_spawner_platform_spawned(view_name, x_beg, x_end, y_position):
    if not _should_spawn():
        return

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

