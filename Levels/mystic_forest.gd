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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ColorController.current_game_color = ColorController.GameColor.PURPLE
	Fruits.colors_eaten = [ ColorController.GameColor.GREEN,  ColorController.GameColor.RED,  ColorController.GameColor.YELLOW, ColorController.GameColor.BLUE, ColorController.GameColor.PURPLE]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_arena_area_body_entered(body: Node2D) -> void:
	$AudioStreamPlayer2D.stop()
	$FastBg.play()
