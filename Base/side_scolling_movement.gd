extends Node
class_name SideScrollingMovement

# Movement & jump tuning (alphabetical).
@export var GRAVITY: float = 2000.0
@export var JUMP_CUT_GRAVITY_SCALE: float = 2.0
@export var JUMP_HOLD_GRAVITY_SCALE: float = 0.35
@export var JUMP_VELOCITY: float = -900.0
@export var MAX_JUMP_HOLD_TIME: float = 0.25
@export var SPEED: float = 1000.0

# Assign your Sprite2D or AnimatedSprite2D here in the inspector.
@export var visual_path: NodePath

var controlled_body: CharacterBody2D
var facing: int = 1
var _is_jumping: bool = false
var _jump_held_time: float = 0.0
var _visual: Node = null

func _ready() -> void:
	if owner is CharacterBody2D:
		controlled_body = owner
	else:
		push_error("SideScrollingMovement must be a child of a CharacterBody2D node.")
		return

	if visual_path != NodePath():
		_visual = get_node_or_null(visual_path)
	else:
		push_error("Assign a visual node (Sprite2D/AnimatedSprite2D) to 'visual_path'.")

func _set_facing(dir: int) -> void:
	facing = dir
	# Flip only the visual; leave the body unscaled.
	if _visual is Sprite2D:
		(_visual as Sprite2D).flip_h = facing < 0
	elif _visual is AnimatedSprite2D:
		(_visual as AnimatedSprite2D).flip_h = facing < 0
	elif _visual is Node2D:
		# Fallback if it's some other Node2D with zero rotation.
		(_visual as Node2D).scale = Vector2(float(facing), 1.0)

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
		if _is_jumping and Input.is_action_pressed("ui_up") and _jump_held_time < MAX_JUMP_HOLD_TIME:
			gravity_scale = JUMP_HOLD_GRAVITY_SCALE
			_jump_held_time += delta
		else:
			gravity_scale = JUMP_CUT_GRAVITY_SCALE
	else:
		gravity_scale = 1.0

	controlled_body.velocity.y += GRAVITY * gravity_scale * delta

	# Reset jump state on landing.
	if controlled_body.is_on_floor() and controlled_body.velocity.y >= 0.0:
		_is_jumping = false
		_jump_held_time = 0.0

	# --- Horizontal movement ---
	var direction: float = Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		_set_facing(-1 if direction < 0.0 else 1)
		controlled_body.velocity.x = direction * SPEED
	else:
		# Smooth deceleration; actually scale by delta.
		controlled_body.velocity.x = move_toward(controlled_body.velocity.x, 0.0, SPEED )

	controlled_body.move_and_slide()
