extends ChefBaseState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta: float) -> int:
	return ChefBaseState.State.Idle

	
func input(event: InputEvent) -> int:
	return ChefBaseState.State.Idle
