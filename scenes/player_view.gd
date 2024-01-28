extends Node2D

@onready var background_rect = $Background.get_rect()
var the_other_view = null

const scroll_speed = 60
const scroll_speed_boost = 2.7

var scroll_speed_boost_active := false

func _ready():
    $PlatformContainer.transform = $Background.transform

func _process(delta):
    var increment = scroll_speed * delta
    if scroll_speed_boost_active:
        increment *= scroll_speed_boost
    $PlatformContainer.position.y += increment

func _on_player_enter_scroll_boost(_body_rid, body, _body_shape_index, _local_shape_index):
    # Check if this is our player
    if body.player_idx != $Player.player_idx:
        return

    scroll_speed_boost_active = true


func _on_player_exit_scroll_boost(_body_rid, body, _body_shape_index, _local_shape_index):
    # Check if this is our player
    if body.player_idx != $Player.player_idx:
        return

    scroll_speed_boost_active = false
