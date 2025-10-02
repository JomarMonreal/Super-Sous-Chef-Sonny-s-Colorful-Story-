extends EnemyBaseState

var oscillation_time: float = 0.0
var hurt_duration: float = 0.5              # how long the hurt state lasts
var knockback_speed: float = 320.0          # initial push strength
var knockback_damp: float = 8.0             # easing factor

func enter() -> void:
	oscillation_time = 0.0

	var enemy := entity as Enemy
	_start_blinking(enemy, 3, 0.09)
	print(enemy.collider_entered)

	# Apply knockback away from attacker
	if enemy.collider_entered is Node2D:
		var intruder := enemy.collider_entered as Node2D
		var dir_x = sign(enemy.global_position.x - intruder.global_position.x)
		enemy.velocity.x = dir_x * knockback_speed


func physics_process(delta: float) -> int:
	var enemy := entity as Enemy

	oscillation_time += delta
	if oscillation_time > hurt_duration:
		return EnemyBaseState.State.Moving

	# Apply gravity
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity() * delta

	# Smooth knockback decay
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, knockback_damp * delta * knockback_speed)

	# ✅ Important: move the character with its velocity
	enemy.move_and_slide()

	return EnemyBaseState.State.Hurt


func _start_blinking(enemy: Enemy, blinks: int, interval: float) -> void:
	blink(blinks, interval, enemy)


func blink(blinks: int, interval: float, enemy: Enemy) -> void:
	await get_tree().process_frame
	for i in range(blinks * 2):
		enemy.sprite.visible = not enemy.sprite.visible
		await get_tree().create_timer(interval).timeout
	enemy.sprite.visible = true
