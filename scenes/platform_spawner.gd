extends Node2D

var tile_size
var tile_dimensions

# Computes size of a platofrm tile in pixels
func _compute_tile_size(player_view_dims):
	var desired_tile_dim = 64 # Same is used for height and width
	return Vector2i(desired_tile_dim, desired_tile_dim)

# Computes how many tiles fit horizontally and vertically on a single player_view
func _compute_tile_dimensions(player_view_dims):
	var tile_size = _compute_tile_size(player_view_dims)
	var horizontal_tiles_num = player_view_dims.size.x / tile_size.x
	var vertical_tiles_num = player_view_dims.size.y / tile_size.x
	return Vector2i(horizontal_tiles_num, vertical_tiles_num)

func _spawn_tiles(tiles_dimensions, tile_size):
	var root = get_parent()
	
	var tile = preload("res://scenes/platform_tile.tscn")
	
	for r in tiles_dimensions.y:
		for c in tiles_dimensions.x:
			var instance = tile.instantiate()
			instance.position.x = (r * tile_size.x)
			instance.position.y = (c * tile_size.y)
			root.add_child.call_deferred(instance)


# Called when the node enters the scene tree for the first time.
func _ready():
	var player_view_node = get_node("../PlayerView").find_child("Background")
	var player_view_dims = player_view_node.get_rect()
	var tile_size = _compute_tile_size(player_view_dims)
	var tiles_dimensions = _compute_tile_dimensions(player_view_dims)
	print(tile_dimensions)
	
	_spawn_tiles(tiles_dimensions, tile_size)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
