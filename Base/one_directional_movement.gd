extends Node
class_name OneDirectionalMovement

@export var speed: float = 200.0
@export var is_randomized: bool = true
@export var direction: Vector2 = Vector2(0, 1)

var controlled_body: RigidBody2D

func _ready() -> void:
	if owner is RigidBody2D:
		controlled_body = owner as RigidBody2D

		# Ensure collisions fire and fast bullets don’t tunnel.
		controlled_body.contact_monitor = true
		controlled_body.max_contacts_reported = 8
		controlled_body.continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY

		# Randomize initial direction if requested.
		if is_randomized:
			var angle := randf_range(0.0, TAU)
			direction = Vector2(cos(angle), sin(angle)).normalized()
	else:
		push_error("OneDirectionalMovement must be a child of a RigidBody2D node.")

func _physics_process(delta: float) -> void:
	if controlled_body:
		controlled_body.linear_velocity = direction * speed

func _on_bullet_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body == controlled_body:
		return
	controlled_body.queue_free() # Free the BULLET, not this controller node.

func _on_bullet_body_entered(body: Node) -> void:
	if body == controlled_body:
		return
	controlled_body.queue_free()
