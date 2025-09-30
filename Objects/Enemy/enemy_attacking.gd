extends EnemyBaseState

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var enemy := entity as Enemy
	enemy.sprite.play("Attacking")
	enemy.dash_controller.start_dash(Vector2(enemy.character_movement.direction, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var enemy := entity as Enemy
	enemy.dash_controller.process_dash(delta)		
	if !enemy.dash_controller.is_dashing and !enemy.dash_controller.is_on_cooldown and !enemy.dash_controller.is_delaying:
		return EnemyBaseState.State.Moving
		
	return EnemyBaseState.State.Attaking
