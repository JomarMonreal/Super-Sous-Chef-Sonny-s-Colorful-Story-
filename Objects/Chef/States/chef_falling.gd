extends ChefBaseState


# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var chef := entity as Chef
	chef.sprite.play("Falling")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var chef := entity as Chef
	chef.character_movement.move(delta)		
	if Input.is_action_just_pressed("dash"):
		return ChefBaseState.State.Dashing
		
	if chef.is_on_floor():
		return ChefBaseState.State.Idle
		
	return ChefBaseState.State.Falling
