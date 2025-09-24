extends CharacterBody2D
class_name Chef


@onready var states: SpiderStateManager = $StateManager

func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
