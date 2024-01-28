extends CharacterBody2D

const SPEED = 213.7 * 2.137

signal pushAnvilCollided(affected_player_idx : int)

func _physics_process(delta):
    velocity.y += SPEED * delta
    var collided = move_and_slide()
    if collided:
        pushAnvilCollided.emit()
        queue_free()
