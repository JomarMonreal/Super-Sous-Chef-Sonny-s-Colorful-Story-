extends EnemyBaseState

@onready var guard_timer: Timer = $GuardDuration

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var enemy := entity as Boss
	enemy.sprite.play(enemy.node_color_name + " Guarding")
	guard_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float) -> int:
	return EnemyBaseState.State.Guarding

func _on_guard_duration_timeout() -> void:
	var enemy := entity as Boss
	if guard_timer:
		guard_timer.stop()
		enemy.states.change_state(EnemyBaseState.State.Moving)
