extends Node2D

signal platformSpawned(view_name, x_beg, x_end, y_position)

var last_platform_spawn_position : float = 0.0
var last_platform_spawn_row_idx : int = -2

# Computes size of a platofrm tile in pixels
func _compute_tile_size(_player_view_rect):
    var desired_tile_dim = Settings.TILE_SIZE # Same is used for height and width
    #print("Is tile_size_divisible? %s" % ("No" if int(player_view_rect.size.x) % desired_tile_dim else "Yes"))
    return Vector2i(desired_tile_dim, desired_tile_dim)

# Computes how many tiles fit horizontally and vertically on a single player_view
func _compute_tile_dimensions(player_view_rect):
    var tile_size = _compute_tile_size(player_view_rect)
    var horizontal_tiles_num = player_view_rect.size.x / tile_size.x
    var vertical_tiles_num = player_view_rect.size.y / tile_size.x
    return Vector2i(horizontal_tiles_num, vertical_tiles_num)

func _pixel_pos_from_column_row(column, row, tile_size, player_view_rect):
    var x = (column * tile_size.x) + player_view_rect.position.x + (tile_size.x / 2)
    var y = (row * tile_size.y) + player_view_rect.position.y + (tile_size.y / 2)
    return { x = x, y = y }

func _create_tile(tile_scene, column, row, tile_size, player_view_rect):
    var instance = tile_scene.instantiate()
    var position = _pixel_pos_from_column_row(column, row, tile_size, player_view_rect)
    instance.position.x = position.x
    instance.position.y = position.y
    instance.name = "PlatformTile_x%d_y%d" % [column, row]
    return instance

func _fill_starting_platform_tiles(root, tile, tile_size, row, tiles_in_a_row, player_view_rect):
    for c in tiles_in_a_row:
        var instance = _create_tile(tile, c, row, tile_size, player_view_rect)
        root.add_child.call_deferred(instance)

func _generate_platform_size_and_offset(tiles_in_a_row):
    var platform_length = max(randi() % tiles_in_a_row, Settings.MIN_ROW_LENGTH)
    var offset_range = tiles_in_a_row - platform_length
    var platform_offset = randi() % offset_range
    return { platform_offset = platform_offset, platform_length = platform_length}

func _fill_platform_tiles(platform_offset, platform_length, root, tile, row, tile_size, player_view_rect):
    for c in platform_length:
        var column = platform_offset + c
        var instance = _create_tile(tile, column, row, tile_size, player_view_rect)
        root.add_child.call_deferred(instance)

func _init_platforms(player_view_name, tiles_dimensions, tile_size, player_view_rect):
    var root = get_parent().find_child(player_view_name).find_child("PlatformContainer")
    var tile = preload("res://scenes/platform_tile.tscn")

    var tiles_in_a_row = tiles_dimensions.x
    var rows_number = tiles_dimensions.y

    for r in range(rows_number - 1, -1, -1):
        if r == rows_number - 1: # fill the first row to full capacity
            _fill_starting_platform_tiles(root, tile, tile_size, r, tiles_in_a_row, player_view_rect)
        if r % 2: # Skip every second platform to leave blank rows between
            continue
        var size_and_offset = _generate_platform_size_and_offset(tiles_in_a_row)
        var platform_length = size_and_offset.platform_length
        var platform_offset = size_and_offset.platform_offset
        _fill_platform_tiles(platform_offset, platform_length, root, tile, r, tile_size, player_view_rect)


func _spawn_new_platform(player_view_name):
    var player_view_rect =  get_parent().find_child(player_view_name).background_rect
    var tile_size = _compute_tile_size(player_view_rect)
    var tiles_dimensions = _compute_tile_dimensions(player_view_rect)

    var root = get_parent().find_child(player_view_name).find_child("PlatformContainer")
    var tile = preload("res://scenes/platform_tile.tscn")

    var tiles_in_a_row = tiles_dimensions.x
    var r = last_platform_spawn_row_idx
    var size_and_offset = _generate_platform_size_and_offset(tiles_in_a_row)
    var platform_length = size_and_offset.platform_length
    var platform_offset = size_and_offset.platform_offset
    _fill_platform_tiles(platform_offset, platform_length, root, tile, r, tile_size, player_view_rect)
    _emit_spawned_signal(player_view_name)

func _emit_spawned_signal(player_view_name):
    var player_view_rect =  get_parent().find_child(player_view_name).background_rect
    var tile_size = _compute_tile_size(player_view_rect)
    var row = last_platform_spawn_row_idx - 1
    var column = 0
    var position = _pixel_pos_from_column_row(column, row, tile_size, player_view_rect)
    var y_position = position.y
    var x_beg = player_view_rect.position.x
    var x_end = player_view_rect.size.x + player_view_rect.position.x
    emit_signal("platformSpawned", player_view_name, x_beg, x_end, y_position)

# Called when the node enters the scene tree for the first time.
func _ready():
    var player_view_rect =  get_node("../PlayerView").background_rect
    var tile_size = _compute_tile_size(player_view_rect)
    var tiles_dimensions = _compute_tile_dimensions(player_view_rect)

    _init_platforms("PlayerView", tiles_dimensions, tile_size, player_view_rect)
    _init_platforms("PlayerView2", tiles_dimensions, tile_size, player_view_rect)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    var container = get_node("../PlayerView/PlatformContainer")
    var container_y = container.position.y
    var increment = (container.scale.y * Settings.TILE_SIZE) * 2
    var last_platform_pos_incremented = last_platform_spawn_position + increment
    if container_y > last_platform_pos_incremented:
        last_platform_spawn_position += increment
        _spawn_new_platform("PlayerView")
        _spawn_new_platform("PlayerView2")
        last_platform_spawn_row_idx -= 2 # Set new row index two tows above

