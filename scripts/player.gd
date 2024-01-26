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

var move_force = 400
var jump_impulse = -250 # Make sure this value is appropriate for your game's physics scale

func _physics_process(delta):
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

    if input_vector.length() > 0:
        input_vector = input_vector.normalized() * move_force
        apply_central_impulse(input_vector)
    
    # Example of applying a jump impulse (You'll need to implement your own on-the-ground check)
    # if Input.is_action_just_pressed("ui_up") and is_on_ground(): # is_on_ground() is pseudo-code
    #     apply_central_impulse(Vector2(0, jump_impulse))
