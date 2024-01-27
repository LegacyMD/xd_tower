extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
    var tile_size = Settings.TILE_SIZE
    var sprite = get_node("Sprite2D")
    var rect = sprite.get_rect()
    var adjusted_scale = tile_size / rect.size.x

    apply_scale(Vector2(adjusted_scale, adjusted_scale))
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass
