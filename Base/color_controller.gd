extends Node

enum GameColor {RED, GREEN, BLUE, YELLOW, PURPLE, ORANGE, WHITE}
var current_game_color : GameColor = GameColor.WHITE
var COLOR_MAP = {
	GameColor.RED : Color("Red").lightened(0.5),
	GameColor.GREEN : Color("Green").lightened(0.5),
	GameColor.BLUE : Color("Blue").lightened(0.5),
	GameColor.YELLOW : Color("Yellow"),
	GameColor.PURPLE : Color("Purple").lightened(0.5),
	GameColor.ORANGE : Color("Orange"),
	GameColor.WHITE : Color("White").lightened(0.5),
}
var COMPLEMENTARY_MAP = {
	GameColor.RED : GameColor.GREEN,
	GameColor.GREEN : GameColor.RED,
	GameColor.BLUE : GameColor.ORANGE,
	GameColor.YELLOW : GameColor.PURPLE,
	GameColor.PURPLE : GameColor.YELLOW,
	GameColor.ORANGE : GameColor.BLUE,
	GameColor.WHITE : null
}

func set_food() -> void:
	if Input.is_action_just_pressed("eat_red"):
		current_game_color = GameColor.RED
	if Input.is_action_just_pressed("eat_green"):
		current_game_color = GameColor.GREEN
	if Input.is_action_just_pressed("eat_blue"):
		current_game_color = GameColor.BLUE
	if Input.is_action_just_pressed("eat_yellow"):
		current_game_color = GameColor.YELLOW
	if Input.is_action_just_pressed("eat_purple"):
		current_game_color = GameColor.PURPLE
	if Input.is_action_just_pressed("eat_orange"):
		current_game_color = GameColor.ORANGE

func get_food() -> void:
	print(GameColor.find_key(current_game_color))

func _process(delta: float) -> void:
	set_food()
