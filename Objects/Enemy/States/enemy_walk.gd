extends EnemyBaseState


# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var enemy := entity as Enemy
	enemy.sprite.play("Moving")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var enemy := entity as Enemy
	enemy.character_movement.move(delta)		
		
	return EnemyBaseState.State.Moving
