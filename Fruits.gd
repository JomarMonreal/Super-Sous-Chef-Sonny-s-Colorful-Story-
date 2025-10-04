extends Node

@onready var eat_fruit_sfx: AudioStream = load("res://Level Assets/eat_fruit.wav")
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
	elif event.is_action_pressed("eat_red") and ColorController.GameColor.RED in colors_eaten:
		play(eat_fruit_sfx)
	elif event.is_action_pressed("eat_green") and ColorController.GameColor.GREEN in colors_eaten:
		play(eat_fruit_sfx)
	elif event.is_action_pressed("eat_blue") and ColorController.GameColor.BLUE in colors_eaten:
		play(eat_fruit_sfx)
	elif event.is_action_pressed("eat_yellow") and ColorController.GameColor.YELLOW in colors_eaten:
		play(eat_fruit_sfx)
	elif event.is_action_pressed("eat_purple") and ColorController.GameColor.PURPLE in colors_eaten:
		play(eat_fruit_sfx)
	elif event.is_action_pressed("eat_orange") and ColorController.GameColor.ORANGE in colors_eaten:
		play(eat_fruit_sfx)
		
static func play(audio: AudioStream) -> void:
	var audio_player := AudioStreamPlayer2D.new()
	audio_player.stream = audio
	Engine.get_main_loop().root.add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
