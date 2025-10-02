extends ChefBaseState

var oscillation_time = 0
var oscillation_speed = 5

signal chef_dead

func enter() -> void:
	oscillation_time = 0
	var chef := entity as Chef
	_start_blinking(chef, 3, 0.2)  # blink 3 times, 0.2s per toggle


func physics_process(delta: float) -> int:
	var chef := entity as Chef

	# after enough time, mark chef as dead and hide
	if oscillation_time > 8:
		chef_dead.emit()
		chef.sprite.visible = false
		return ChefBaseState.State.Dead

	oscillation_time += delta * oscillation_speed

	return ChefBaseState.State.Dead


func _start_blinking(chef: Chef, blinks: int, interval: float) -> void:
	blink(blinks, interval, chef)


func blink(blinks: int, interval: float, chef: Chef) -> void:
	await get_tree().process_frame
	for i in range(blinks * 2):
		chef.sprite.visible = not chef.sprite.visible
		await get_tree().create_timer(interval).timeout
	# end fully invisible (so it looks “dead”)
	chef.sprite.visible = false
