extends ChefBaseState


# Called when the node enters the scene tree for the first time.
func ready() -> int:
	return ChefBaseState.State.Moving


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var chef := entity as Chef
	chef.character_movement.move(delta)		
	if Input.is_action_just_pressed("ui_accept"):
		return ChefBaseState.State.Dashing
		
	if chef.velocity.x == 0 and chef.velocity.y == 0:
		return ChefBaseState.State.Idle
		
	return ChefBaseState.State.Moving
