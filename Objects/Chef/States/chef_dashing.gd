extends ChefBaseState


# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var chef := entity as Chef
	chef.sprite.play("Dash")
	chef.dash_controller.start_dash(Vector2(chef.character_movement.facing, 0))

func process(_delta: float) -> int:
	var chef := entity as Chef
	chef.dash_controller.process_dash(_delta)
	if !chef.dash_controller.is_dashing:
		return ChefBaseState.State.Idle
	return ChefBaseState.State.Dashing
