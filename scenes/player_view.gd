extends Node2D

@onready var background_rect = $Background.get_rect()
var the_other_view = null

var scroll_speed = 60

func _ready():
    $PlatformContainer.transform = $Background.transform

func _process(delta):
    $PlatformContainer.position.y += scroll_speed * delta
