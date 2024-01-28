extends Node2D

func _ready():
    $PlayerView.the_other_view = $PlayerView2
    $PlayerView2.the_other_view = $PlayerView

    $PlayerView/Player.enemy = $PlayerView2/Player
    $PlayerView2/Player.enemy = $PlayerView/Player

    get_tree().get_root().size_changed.connect(resize)
    resize()

func resize():
    var screen_size = get_viewport().get_visible_rect().size
    var zoom_x = screen_size.x / 1152 # lol
    var zoom_y = screen_size.y / 648 # kek
    var zoom = min(zoom_x, zoom_y)
    $Camera2D.zoom.x = zoom
    $Camera2D.zoom.y = zoom
    print("RESIZE %s, %s" % [screen_size.x, screen_size.y])
