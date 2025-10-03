extends ChefBaseState

var oscillation_time = 0
var oscillation_speed = 5

signal chef_dead

func enter() -> void:
	oscillation_time = 0
	var chef := entity as Chef
	chef.sprite.play("Dead")


func physics_process(delta: float) -> int:
	var chef := entity as Chef

	# after enough time, mark chef as dead and hide
	if oscillation_time > 8:
		chef_dead.emit()
		chef.queue_free()
		get_tree().reload_current_scene()
		return ChefBaseState.State.Dead

	oscillation_time += delta * oscillation_speed

	return ChefBaseState.State.Dead
