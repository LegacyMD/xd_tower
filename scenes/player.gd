extends CharacterBody2D

# TODO move this to some shared place
const collision_layer_obstacle := (1 << 1)
const collision_layer_obstacle_full := (1 << 4)

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

func _input(event):
    var just_pressed = event.is_pressed() and not event.is_echo()
    if Input.is_key_pressed(KEY_R) and just_pressed:
        get_tree().reload_current_scene()

func _ready():
    pass

signal push_player_idx(player_idx)

func _on_area_2d_body_entered(_body):
    push_player_idx.emit(player_idx)

func _process(_delta):
    _check_new_platform()

    # Debug code to test effects
    if Input.is_action_just_pressed("ui_home"):
        _enable_effect(Effect.EffectType.Bounce)
    elif Input.is_action_just_pressed("ui_end"):
        _enable_effect(Effect.EffectType.TwistMovingDirections)


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
        velocity = Vector2(-500, -300)
        collision_mask &= (~collision_layer_obstacle)
        collision_mask |= collision_layer_obstacle_full
    elif effect == Effect.EffectType.TwistMovingDirections:
        horizontal_move_multiplier = -horizontal_move_multiplier
    else:
        print("WARNING: _enable_effect() called with unsupported effect type. Wtf?")

    $EffectEndTimer.wait_time = 1.0 # TODO make this effect-specific?
    $EffectEndTimer.start()


func _disable_effect():
    if active_effect == Effect.EffectType.Bounce:
        velocity = Vector2.ZERO
        collision_mask &= (~collision_layer_obstacle_full)
        collision_mask |= collision_layer_obstacle
    elif active_effect == Effect.EffectType.TwistMovingDirections:
        pass
    else:
        print("WARNING: _disable_effect() called on unsupported effect type. Wtf?")

    active_effect = Effect.EffectType.None
