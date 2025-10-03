extends Node

var colors_eaten: Array[ColorController.GameColor] = []
var is_debug_mode := false
var fruit_path_map = {
	ColorController.GameColor.PURPLE: "res://Levels/mystic_forest.tscn",
	ColorController.GameColor.RED: "res://Levels/forest.tscn",
	ColorController.GameColor.GREEN: "res://Levels/desert.tscn",
	ColorController.GameColor.WHITE: "res://Levels/win.tscn",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_mode"):
		if not is_debug_mode:
			colors_eaten = [0,1,2,3,4,5]
			is_debug_mode = true
		else:
			colors_eaten = []
			is_debug_mode = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
