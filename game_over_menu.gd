extends Control

var paused : bool = false:
    set = paused_from_value

func _input(event : InputEvent):
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

func _on_player_push_player_idx(player_idx):
    var quarter_width = size.x / 4
    var quarters_count = (1 - player_idx) * 2 + 1
    var cup_position = quarter_width * quarters_count
    $VictoryCup.position.x = cup_position

    # TEMP
    if Settings.DISABLE_WINNING:
        return

    var player_label = $GridContainer/PlayerLabel
    var player_label_text = "Player %d wins" % player_idx
    player_label.text = player_label_text
    paused = !paused
