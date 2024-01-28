extends Node2D

func _ready():
    $PlayerView.the_other_view = $PlayerView2
    $PlayerView2.the_other_view = $PlayerView

func _process(delta):
    pass
