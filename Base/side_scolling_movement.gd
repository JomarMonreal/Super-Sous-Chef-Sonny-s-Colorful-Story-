extends Node
class_name SideScrollingMovement

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var controlled_body: CharacterBody2D

func _ready() -> void:
	if owner is CharacterBody2D:
		controlled_body = owner
	else:
		push_error("SideScrollingMovement must be a child of a CharacterBody2D node.")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not controlled_body.is_on_floor():
		controlled_body.velocity += controlled_body.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and controlled_body.is_on_floor():
		controlled_body.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		controlled_body.velocity.x = direction * SPEED
	else:
		controlled_body.velocity.x = move_toward(controlled_body.velocity.x, 0, SPEED)

	controlled_body.move_and_slide()
