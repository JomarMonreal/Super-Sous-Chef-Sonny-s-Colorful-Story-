extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ColorController.current_game_color = ColorController.GameColor.GREEN
	Fruits.colors_eaten = [ ColorController.GameColor.GREEN,  ColorController.GameColor.RED,  ColorController.GameColor.YELLOW]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
