extends Node

var colors_eaten: Array[ColorController.GameColor] = [ColorController.GameColor.GREEN]

var fruit_path_map = {
	ColorController.GameColor.RED: "res://Levels/test.tscn",
	ColorController.GameColor.GREEN: "res://Levels/kitchen.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
