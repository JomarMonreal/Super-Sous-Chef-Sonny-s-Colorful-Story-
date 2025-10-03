extends AnimatedSprite2D

@onready var timer: Timer = $Timer  # make sure you have a Timer as child

func _ready() -> void:
	timer.start()

func _process(delta: float) -> void:
	if timer.time_left > 0:
		# Get percentage of time left (1 → full, 0 → finished)
		var ratio = timer.time_left / timer.wait_time
		modulate.a = ratio  # fade alpha with time
	else:
		modulate.a = 0  # fully transparent when time runs out

func _on_timer_timeout() -> void:
	timer.stop()
	queue_free()  # delete the node when timer finishes
