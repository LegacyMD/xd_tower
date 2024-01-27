extends RigidBody2D

# NOTE(mwk): for each player view, the index is hardcoded
@export var player_idx : int

func add_keyboard_mapping(action_name, keycode):
    var input_event_key = InputEventKey.new()
    input_event_key.physical_keycode = keycode
    InputMap.add_action(action_name)
    InputMap.action_add_event(action_name, input_event_key)

func _ready():
    # mwk: player -> keyboard mappings
    add_keyboard_mapping("player0_up", KEY_W)
    add_keyboard_mapping("player0_down", KEY_S)
    add_keyboard_mapping("player0_left", KEY_A)
    add_keyboard_mapping("player0_right", KEY_D)
 
    add_keyboard_mapping("player1_up", KEY_UP)
    add_keyboard_mapping("player1_down", KEY_DOWN)
    add_keyboard_mapping("player1_left", KEY_LEFT)
    add_keyboard_mapping("player1_right", KEY_RIGHT)
    
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
    # mwk: player index -> player name -> player inputs
    var player_str = "%s%d" % ["player", player_idx]
    var player_up = "%s_%s" % [player_str, "up"]
    var player_down = "%s_%s" % [player_str, "down"]
    var player_left = "%s_%s" % [player_str, "left"]
    var player_right = "%s_%s" % [player_str, "right"]
    
    # mwk: calculate incidental velocity for left and right movements
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength(player_right) - Input.get_action_strength(player_left)
    if input_vector.length() > 0:
        input_vector = input_vector.normalized() * move_force
        apply_central_impulse(input_vector)
    
    # mwk: handle jumping
    if Input.is_action_just_pressed(player_up) and is_on_ground():
        apply_central_impulse(Vector2(0, jump_impulse))
