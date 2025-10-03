extends Area2D
@export var damage: int = 1
func _on_body_entered(body: Node2D) -> void:
	if body is Chef:
		body = body as Chef
		body.health_controller.take_damage(damage)
		print(body.health_controller.health)
		if body.health_controller.health <= 0:
			body.states.change_state(ChefBaseState.State.Dead)
			return
		body.states.change_state(ChefBaseState.State.Hurt)
