# from Youtube Tutorial "Easy Input Settings Menu | Let's Godot" (youtube.com/watch?v=ZDPM45cHHIlI)
extends Node

@onready var pause_menu = $GUI/InpuptSettings

var game_paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
		if game_paused:
			Engine.time_scale = 0
			pause_menu.visible = true
		else:
			Engine.time_scale = 1
			pause_menu.visible = false
		get_tree().root.get_viewport().set_input_as_handled()
