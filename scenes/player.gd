extends CharacterBody2D

# NOTE(mwk): for each player view, the index is hardcoded
@export var player_idx : int

var horizontal_move_multiplier = 30
var vertical_jump_multiplier = 950
var vertical_fall_multiplier = 1000
var gravity := 55

func add_keyboard_mapping(action_name, keycode):
    var input_event_key = InputEventKey.new()
    input_event_key.physical_keycode = keycode
    InputMap.add_action(action_name)
    InputMap.action_add_event(action_name, input_event_key)

func add_gamepad_button_mapping(action_name, gamepad_button_index, device := -1):
    var input_event_joypad_button = InputEventJoypadButton.new()
    input_event_joypad_button.button_index = gamepad_button_index
    input_event_joypad_button.device = device
    InputMap.add_action(action_name)
    InputMap.action_add_event(action_name, input_event_joypad_button)

func add_gamepad_axis_mapping(action_name, axis, axis_value, device := -1):
    var input_event_joypad_motion = InputEventJoypadMotion.new()
    input_event_joypad_motion.axis = axis
    input_event_joypad_motion.axis_value = axis_value
    input_event_joypad_motion.device = device
    InputMap.add_action(action_name)
    InputMap.action_add_event(action_name, input_event_joypad_motion)

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

    # mwk: player -> gamepad mappings
    add_gamepad_axis_mapping("player0_left", JOY_AXIS_LEFT_X, -1)
    add_gamepad_axis_mapping("player0_right", JOY_AXIS_LEFT_X, 1)
    add_gamepad_axis_mapping("player0_down", JOY_AXIS_LEFT_Y, 1)
    add_gamepad_button_mapping("player0_jump", JOY_BUTTON_A)

    add_gamepad_axis_mapping("player1_left", JOY_AXIS_LEFT_X, -1, 1)
    add_gamepad_axis_mapping("player1_right", JOY_AXIS_LEFT_X, 1, 1)
    add_gamepad_axis_mapping("player1_down", JOY_AXIS_LEFT_Y, 1, 1)
    add_gamepad_button_mapping("player1_jump", JOY_BUTTON_A, 1)

func _on_area_2d_body_entered(body):
    #print("JA PIERDOLE")
    pass

func _physics_process(delta):
    velocity.y += gravity

    # mwk: player index -> player name -> player inputs
    var player_str = "%s%d" % ["player", player_idx]
    var player_up = "%s_%s" % [player_str, "up"]
    var player_down = "%s_%s" % [player_str, "down"]
    var player_left = "%s_%s" % [player_str, "left"]
    var player_right = "%s_%s" % [player_str, "right"]

    # mwk: calculate incidental velocity for left and right movements
    var horizontal_input := Input.get_action_strength(player_right) - Input.get_action_strength(player_left)
    velocity.x += horizontal_input * horizontal_move_multiplier
    if horizontal_input > 0:
        velocity.x = max(velocity.x, 0)
    elif horizontal_input < 0:
        velocity.x = min(velocity.x, 0)

    # mwk: handle jumping
    if Input.is_action_just_pressed(player_up) and is_on_floor():
        velocity.y -= vertical_jump_multiplier

    if Input.is_action_just_pressed(player_down):
        velocity.y += vertical_fall_multiplier
        velocity.y = max(velocity.y, 0)

    move_and_slide()
