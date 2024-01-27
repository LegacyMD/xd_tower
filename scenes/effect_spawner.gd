extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _should_spawn():
    return randf() <= Settings.EFFECT_SPAWN_CHANCE

func _generate_x_pos(x_beg, x_end):
    var range = x_end - x_beg
    return randf() * range + x_beg

func _on_platform_spawner_platform_spawned(view_name, x_beg, x_end, y_position):
    if not _should_spawn():
        return
    
    var effect = preload("res://scenes/effect.tscn")
    
    var instance = effect.instantiate()
    instance.position.x = _generate_x_pos(x_beg, x_end)
    instance.position.y = y_position
    instance.name = "Effect_y%d" % [int(y_position)]
    
    var container = get_node("../%s/PlatformContainer" % view_name)
    container.add_child(instance)
    #return instance
    #print(x_beg, x_end, y_position)
