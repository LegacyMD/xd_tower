extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
    var screen_size = get_viewport_rect().size
    print(screen_size)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_area_2d_body_entered(body):
    print("JA PIERDOLE")
    pass # Replace with function body.

var move_force = 10
var jump_impulse = -10
var on_ground = false

func is_on_ground() -> bool:
    return on_ground

func _physics_process(delta):
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

    if input_vector.length() > 0:
        input_vector = input_vector.normalized() * move_force
        apply_central_impulse(input_vector)
    
    if Input.is_action_just_pressed("ui_up") and is_on_ground():
        apply_central_impulse(Vector2(0, jump_impulse))
