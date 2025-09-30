extends Node
class_name SideScrollingWalkMovement

@export var SPEED = 20.0
@export var left_ray: RayCast2D
@export var right_ray: RayCast2D
@export var is_facing_right = true

@export var visual_path: NodePath
var _visual: Node = null
var direction = 1

var controlled_body: CharacterBody2D

func _ready() -> void:
	if owner is CharacterBody2D:
		controlled_body = owner
	else:
		push_error("SideScrollingWalkMovement must be a child of a CharacterBody2D node.")
		return
		
		
	if visual_path != NodePath():
		_visual = get_node_or_null(visual_path)
	else:
		push_error("Assign a visual node (Sprite2D/AnimatedSprite2D) to 'visual_path'.")
	direction = 1 if randi_range(0,100) > 50 else -1
	_set_facing(direction)

func _set_facing(dir: int) -> void:
	direction = dir 
	# Flip only the visual; leave the body unscaled.
	if _visual is Sprite2D:
		(_visual as Sprite2D).flip_h = direction < 0
	elif _visual is AnimatedSprite2D:
		(_visual as AnimatedSprite2D).flip_h = direction < 0 if is_facing_right else direction > 0
	elif _visual is Node2D:
		# Fallback if it's some other Node2D with zero rotation.
		(_visual as Node2D).scale = Vector2(float(direction), 1.0)
		
func move(delta: float) -> void:
	# Add the gravity.
	if not controlled_body.is_on_floor():
		controlled_body.velocity += controlled_body.get_gravity() * delta

	if (right_ray.is_colliding() and direction == 1) or (left_ray.is_colliding() and direction == -1):
		direction *= -1
		_set_facing(direction)
		
	# Get the input direction and handle the movement/deceleration.
	controlled_body.velocity.x = direction * SPEED
	
	
	controlled_body.move_and_slide()
