extends Node2D

# Computes size of a platofrm tile in pixels
func _compute_tile_size(player_view_rect):
    var desired_tile_dim = Settings.TILE_SIZE # Same is used for height and width
    print("Is tile_size_divisible")
    print(player_view_rect.size.x / desired_tile_dim)
    return Vector2i(desired_tile_dim, desired_tile_dim)

# Computes how many tiles fit horizontally and vertically on a single player_view
func _compute_tile_dimensions(player_view_rect):
    var tile_size = _compute_tile_size(player_view_rect)
    var horizontal_tiles_num = player_view_rect.size.x / tile_size.x
    var vertical_tiles_num = player_view_rect.size.y / tile_size.x
    return Vector2i(horizontal_tiles_num, vertical_tiles_num)

func _should_add_tile():
    var probability = 0.1
    return randf() < probability

func _create_tile(tile_scene, column, row, tile_size, player_view_rect):
    var instance = tile_scene.instantiate()
    instance.position.x = (column * tile_size.x) + player_view_rect.position.x + (tile_size.x / 2)
    instance.position.y = (row * tile_size.y) + player_view_rect.position.y + (tile_size.y / 2)
    instance.name = "PlatformTile_x%d_y%d" % [column, row]
    return instance

func _spawn_tiles(player_view_name, tiles_dimensions, tile_size, player_view_rect):
    var root = get_parent().find_child(player_view_name).find_child("Background")
    var tile = preload("res://scenes/platform_tile.tscn")

    var tiles_in_a_row = tiles_dimensions.x
    var rows_number = tiles_dimensions.y

    for r in rows_number:
        if r % 2: # Skip every second platform to leave blank rows between
            continue
        var platform_length = max(randi() % tiles_in_a_row, Settings.MIN_ROW_LENGTH)
        var offset_range = tiles_in_a_row - platform_length
        var platform_offset = randi() % offset_range
        for c in platform_length:
            var column = platform_offset + c
            var instance = _create_tile(tile, column, r, tile_size, player_view_rect)
            root.add_child.call_deferred(instance)

# Called when the node enters the scene tree for the first time.
func _ready():
    var player_view_node = get_node("../PlayerView").find_child("Background")
    var player_view_rect = player_view_node.get_rect()
    var tile_size = _compute_tile_size(player_view_rect)
    var tiles_dimensions = _compute_tile_dimensions(player_view_rect)

    _spawn_tiles("PlayerView", tiles_dimensions, tile_size, player_view_rect)
    _spawn_tiles("PlayerView2", tiles_dimensions, tile_size, player_view_rect)
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
