extends Control

var paused : bool = false:
    set = paused_from_value

func _unhandled_input(event : InputEvent):
    if event.is_action_pressed("ui_cancel"):
        paused = !paused

func paused_from_value(v : bool):
    paused = v
    get_tree().paused = paused
    visible = paused

func _ready():
    paused = false
    visible = false

func _process(delta):
    pass

func _on_resume_button_pressed():
    paused = false

func _on_restart_button_pressed():
    get_tree().reload_current_scene()

func _on_quit_button_pressed():
    get_tree().quit()
