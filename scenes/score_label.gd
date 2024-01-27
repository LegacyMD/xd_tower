extends Label

func _on_player_score_changed(new_score):
    text = "Score: %s" % new_score
