extends BaseStateManager
class_name ChefStateManager

func _ready() -> void:
	states = {
		ChefBaseState.State.Idle: $Idle,
		ChefBaseState.State.Moving: $Moving,
		ChefBaseState.State.Jumping: $Jumping,
		ChefBaseState.State.Falling: $Falling,
		ChefBaseState.State.Dashing: $Dashing,
		ChefBaseState.State.Hurt: $Hurt,
		ChefBaseState.State.Dead: $Dead,
	}

	initial_state = ChefBaseState.State.Idle
