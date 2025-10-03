extends Node2D
class_name SFXController

@export_category("Sounds")
@export var hurt: Array[AudioStream]
@export var attack: Array[AudioStream]
@export var block: Array[AudioStream]
@export var die: Array[AudioStream]
@export var jump: Array[AudioStream]

@export_range(0.00,1.0) var random_pitch_range: float
enum SFX {HURT,ATTACK,BLOCK,DIE,JUMP}

@onready var SFX_MAP = {
	SFX.HURT : hurt,
	SFX.ATTACK : attack,
	SFX.BLOCK : block,
	SFX.DIE : die,
	SFX.JUMP : jump
}


func play(sound: SFX) -> Signal:
	
	var sounds = SFX_MAP[sound]
	if sounds.is_empty():
		return Signal()

	var stream = sounds.pick_random()
	
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	
	randomize()
	var pitch_scale = randf_range(1.0 - random_pitch_range, 1.0 + random_pitch_range)
	player.pitch_scale = pitch_scale
	player.play()
	
	player.finished.connect(player.queue_free)

	return player.finished
