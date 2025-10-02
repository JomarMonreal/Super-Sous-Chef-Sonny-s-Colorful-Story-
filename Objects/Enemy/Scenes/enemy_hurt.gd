extends EnemyBaseState

var oscillation_time: float = 0.0
var oscillation_speed: float = 5.0          # how quickly hurt time ends
var knockback_speed: float = 280.0          # push strength
var knockback_damp: float = 10.0            # easing toward 0 velocity

func enter() -> void:
	oscillation_time = 0.0
	var enemy := entity as Enemy

	# knockback away from attacker if we have reference
	if enemy.last_attacker and enemy.last_attacker is Node2D:
		var dx = enemy.global_position.x - enemy.last_attacker.global_position.x
		var dir_x := 1.0 if dx > 0 else -1.0
		enemy.character_movement.velocity.x = dir_x * knockback_speed
	
	# play hurt animation if available
	if enemy.sprite.has_animation("Hurt"):
		enemy.sprite.play("Hurt")

	# blink 3 times
	_start_blinking(enemy, 3, 0.15)


func process(delta: float) -> int:
	var enemy := entity as Enemy

	# end hurt window
	if oscillation_time > 1.0:
		enemy.character_movement.velocity.x = 0.0
		return EnemyBaseState.State.Moving   # back to moving (or Idle if you prefer)

	oscillation_time += delta * oscillation_speed

	# gravity if airborne
	if not enemy.is_on_floor():
		enemy.character_movement.velocity += enemy.get_gravity() * delta

	# damp knockback
	enemy.character_movement.velocity.x = move_toward(
		enemy.character_movement.velocity.x,
		0.0,
		knockback_damp * knockback_speed * delta
	)

	enemy.character_movement.move(delta)
	return EnemyBaseState.State.Hurt


# --- Blinking Helper ---
func _start_blinking(enemy: Enemy, blinks: int, interval: float) -> void:
	blink(blinks, interval, enemy)

func blink(blinks: int, interval: float, enemy: Enemy) -> void:
	await get_tree().process_frame
	for i in range(blinks * 2):
		enemy.sprite.visible = not enemy.sprite.visible
		await get_tree().create_timer(interval).timeout
	enemy.sprite.visible = true
