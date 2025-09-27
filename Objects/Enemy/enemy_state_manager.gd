extends BaseStateManager
class_name EnemyStateManager

func _ready() -> void:
	states = {
		EnemyBaseState.State.Moving: $Moving,
		EnemyBaseState.State.Attaking: $Attacking,
		EnemyBaseState.State.Hurt: $Hurt,
		EnemyBaseState.State.Dead: $Dead,
	}

	initial_state = EnemyBaseState.State.Moving
