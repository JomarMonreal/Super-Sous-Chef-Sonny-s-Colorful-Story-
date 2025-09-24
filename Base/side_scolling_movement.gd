extends Node
class_name SideScrollingMovement

# Movement & jump tuning (alphabetical).
@export var GRAVITY: float = 2000.0
@export var JUMP_CUT_GRAVITY_SCALE: float = 2.0         # Extra gravity when jump is released early (snappier short hops).
@export var JUMP_HOLD_GRAVITY_SCALE: float = 0.35       # Reduced gravity while the button is held (higher jump).
@export var JUMP_VELOCITY: float = -900.0               # Initial upward impulse (pixels/sec).
@export var MAX_JUMP_HOLD_TIME: float = 0.25            # Max seconds the hold can extend jump height.
@export var SPEED: float = 1000.0

var controlled_body: CharacterBody2D
var facing: int = 1
var _is_jumping: bool = false
var _jump_held_time: float = 0.0

func _ready() -> void:
	if owner is CharacterBody2D:
		controlled_body = owner
	else:
		push_error("SideScrollingMovement must be a child of a CharacterBody2D node.")

func move(delta: float) -> void:
	# --- Jump start / state ---
	if Input.is_action_just_pressed("ui_up") and controlled_body.is_on_floor():
		controlled_body.velocity.y = JUMP_VELOCITY
		_is_jumping = true
		_jump_held_time = 0.0

	if Input.is_action_just_released("ui_up"):
		_is_jumping = false

	# --- Gravity with variable-height logic ---
	var gravity_scale: float = 1.0

	if controlled_body.velocity.y < 0.0:
		# Ascending.
		if _is_jumping and Input.is_action_pressed("ui_up") and _jump_held_time < MAX_JUMP_HOLD_TIME:
			gravity_scale = JUMP_HOLD_GRAVITY_SCALE
			_jump_held_time += delta
		else:
			# Button not held (or cap reached): increase gravity to cut jump short.
			gravity_scale = JUMP_CUT_GRAVITY_SCALE
	else:
		# Falling: use normal gravity (adjust if you want faster falls).
		gravity_scale = 1.0

	controlled_body.velocity.y += GRAVITY * gravity_scale * delta

	# Reset jump state on landing.
	if controlled_body.is_on_floor() and controlled_body.velocity.y >= 0.0:
		_is_jumping = false
		_jump_held_time = 0.0

	# --- Horizontal movement ---
	var direction: float = Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		facing = -1 if direction < 0 else 1
		controlled_body.velocity.x = direction * SPEED
	else:
		# Smooth deceleration; scale by delta.
		controlled_body.velocity.x = move_toward(controlled_body.velocity.x, 0.0, SPEED)

	controlled_body.move_and_slide()
