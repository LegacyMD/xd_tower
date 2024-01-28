extends CharacterBody2D

const SPEED = 213.7 * 2.137

func _physics_process(delta):
    velocity.y += SPEED * delta
    var collided = move_and_slide()
    if collided:
        queue_free()
