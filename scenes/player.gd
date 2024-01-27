extends CharacterBody2D

# NOTE(mwk): for each player view, the index is hardcoded
@export var player_idx : int

signal score_changed(new_score)

var horizontal_move_multiplier = 30000
var vertical_jump_multiplier = 57000
var vertical_fall_multiplier = 60000
var gravity_multiplier = 3300

var score := 0
var min_platform_y = 100000 # Used to keep track of score
const score_for_new_platform = 100
const score_for_new_effect = 500

var active_effect = Effect.EffectType.None

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
    #add_gamepad_axis_mapping("player0_left", JOY_AXIS_LEFT_X, -1)
    #add_gamepad_axis_mapping("player0_right", JOY_AXIS_LEFT_X, 1)
    #add_gamepad_axis_mapping("player0_down", JOY_AXIS_LEFT_Y, 1)
    #add_gamepad_button_mapping("player0_jump", JOY_BUTTON_A)
#
    #add_gamepad_axis_mapping("player1_left", JOY_AXIS_LEFT_X, -1, 1)
    #add_gamepad_axis_mapping("player1_right", JOY_AXIS_LEFT_X, 1, 1)
    #add_gamepad_axis_mapping("player1_down", JOY_AXIS_LEFT_Y, 1, 1)
    #add_gamepad_button_mapping("player1_jump", JOY_BUTTON_A, 1)

signal push_player_idx(player_idx)

func _on_area_2d_body_entered(_body):
    push_player_idx.emit(player_idx)

func _process(_delta):
    _check_new_platform()

    # Debug code to test effects
    if Input.is_action_just_pressed("ui_home"):
        _enable_effect(Effect.EffectType.Bounce)


func _physics_process(delta):
    if active_effect == Effect.EffectType.Bounce:
        _process_bounce_effect_physics(delta)
    else:
        _process_normal_physics(delta)

func _process_bounce_effect_physics(delta):
    var collision : KinematicCollision2D = move_and_collide(velocity * delta)
    if collision:
        # Why the fuck do I have to do this? No clue, but it
        # works somehow...
        var normal := collision.get_normal()
        normal = Vector2(normal.y, normal.x)

        velocity = velocity.reflect(normal)

func _process_normal_physics(delta):
    velocity.y += delta * gravity_multiplier

    # mwk: player index -> player name -> player inputs
    var player_str = "%s%d" % ["player", player_idx]
    var player_up = "%s_%s" % [player_str, "up"]
    var player_down = "%s_%s" % [player_str, "down"]
    var player_left = "%s_%s" % [player_str, "left"]
    var player_right = "%s_%s" % [player_str, "right"]

    # mwk: calculate incidental velocity for left and right movements
    var horizontal_input := Input.get_action_strength(player_right) - Input.get_action_strength(player_left)
    velocity.x = delta * horizontal_input * horizontal_move_multiplier
    if horizontal_input > 0:
        velocity.x = max(velocity.x, 0)
    elif horizontal_input < 0:
        velocity.x = min(velocity.x, 0)

    # mwk: handle jumping
    if Input.is_action_just_pressed(player_up) and is_on_floor():
        velocity.y -= delta * vertical_jump_multiplier
    # mdziuban: handle dropping down
    if Input.is_action_just_pressed(player_down):
        if is_on_floor():
            # If standing on a platform, drop below it
            position.y += 5

        # Accelerate further down
        velocity.y += delta * vertical_fall_multiplier
        velocity.y = max(velocity.y, 0)

    move_and_slide()

func _check_new_platform():
    var position_y = position.y - get_node("../PlatformContainer").position.y

    if is_on_floor():
        if (min_platform_y > position_y):
            min_platform_y = position_y
            add_score(score_for_new_platform)

func add_score(value):
    score += value
    score_changed.emit(score)

func _enable_effect(effect : Effect.EffectType):
    active_effect = effect

    if effect == Effect.EffectType.Bounce:
        print("START BOUNCE")
        velocity = Vector2(-500, -300)
