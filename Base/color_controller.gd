extends Node

enum GameColor {RED, GREEN, BLUE, YELLOW, PURPLE, ORANGE, WHITE}
var current_game_color : GameColor = GameColor.WHITE
var COLOR_MAP = {
	GameColor.RED : Color("Red"),
	GameColor.GREEN : Color("Green"),
	GameColor.BLUE : Color("Blue"),
	GameColor.YELLOW : Color("Yellow"),
	GameColor.PURPLE : Color("Purple"),
	GameColor.ORANGE : Color("Orange"),
	GameColor.WHITE : Color("White"),
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
	if Input.is_action_just_pressed("eat_red") and GameColor.RED in Fruits.colors_eaten:
		current_game_color = GameColor.RED
	if Input.is_action_just_pressed("eat_green") and GameColor.GREEN in Fruits.colors_eaten:
		current_game_color = GameColor.GREEN
	if Input.is_action_just_pressed("eat_blue") and GameColor.BLUE in Fruits.colors_eaten:
		current_game_color = GameColor.BLUE
	if Input.is_action_just_pressed("eat_yellow") and GameColor.YELLOW in Fruits.colors_eaten:
		current_game_color = GameColor.YELLOW
	if Input.is_action_just_pressed("eat_purple") and GameColor.PURPLE in Fruits.colors_eaten:
		current_game_color = GameColor.PURPLE
	if Input.is_action_just_pressed("eat_orange") and GameColor.ORANGE in Fruits.colors_eaten:
		current_game_color = GameColor.ORANGE

func get_food() -> void:
	print(GameColor.find_key(current_game_color))

func _process(delta: float) -> void:
	set_food()
