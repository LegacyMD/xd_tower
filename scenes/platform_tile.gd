extends Node2D

class_name PlatformTile

enum TileType {
    Left,
    Middle,
    Right
}

# Called when the node enters the scene tree for the first time.
func _ready():
    var tile_size = Settings.TILE_SIZE
    var sprite = get_node("Sprite2D")
    var rect = sprite.get_rect()
    var adjusted_scale = tile_size / rect.size.x

    apply_scale(Vector2(adjusted_scale, adjusted_scale))
    pass # Replace with function body.

func set_texture(tile_type : TileType):
    var rect : Rect2

    # Do not comment this.
    # Do not judge me.
    # I don't know how to use texture atlases the cool way.
    # I'll learn someday.
    if tile_type == TileType.Left:
        rect = Rect2(44, 62, 128, 128)
    elif tile_type == TileType.Right:
        rect = Rect2(565, 62, 128, 128)
    else:
        if randi() % 2 == 0:
            rect = Rect2(225, 62, 128, 128)
        else:
            rect = Rect2(391, 62, 128, 128)

    $Sprite2D.region_rect = rect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass
