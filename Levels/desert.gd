extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ColorController.current_game_color = ColorController.GameColor.YELLOW
	Fruits.colors_eaten = [ ColorController.GameColor.YELLOW]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
