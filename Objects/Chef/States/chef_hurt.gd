extends ChefBaseState

var oscillation_time: float = 0.0
var oscillation_speed: float = 5.0          # total hurt duration ≈ 1 / 5 = 0.2s
var knockback_speed: float = 600.0          # initial horizontal push
var knockback_damp: float = 10.0            # how quickly it eases to 0

func enter() -> void:
	oscillation_time = 0.0

	var chef := entity as Chef
	_start_blinking(chef, 3, 0.09)   # blink 3 times, 0.15s per toggle

	if chef.enemy_entered and chef.enemy_entered is Node2D:
		var intruder := chef.enemy_entered as Node2D
		var dx := chef.global_position.x - intruder.global_position.x
		var dir_x := 1.0 if dx > 0.0 else -1.0  # push away horizontally
		chef.velocity.x = dir_x * knockback_speed


func physics_process(delta: float) -> int:
	var chef := entity as Chef

	# end of hurt window
	if oscillation_time > 1.0:
		chef.velocity.x = 0.0
		return ChefBaseState.State.Idle

	oscillation_time += delta * oscillation_speed

	# gravity (keep normal vertical behavior)
	if not chef.is_on_floor():
		chef.velocity += chef.get_gravity() * delta

	# damp horizontal knockback toward zero
	chef.velocity.x = move_toward(chef.velocity.x, 0.0, knockback_damp * knockback_speed * delta)

	chef.move_and_slide()
	return ChefBaseState.State.Hurt


func _start_blinking(chef: Chef, blinks: int, interval: float) -> void:
	# Run this as a coroutine
	blink(blinks, interval, chef)


func blink(blinks: int, interval: float, chef: Chef) -> void:
	# use async toggling
	await get_tree().process_frame
	for i in range(blinks * 2): # visible ↔ invisible counts as 2 steps per blink
		chef.sprite.visible = not chef.sprite.visible
		await get_tree().create_timer(interval).timeout
	# make sure it ends visible
	chef.sprite.visible = true
