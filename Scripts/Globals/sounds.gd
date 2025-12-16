extends Node

var _sounds: Dictionary[String, AudioStream] = {}

func register_sound(id: String, audio: AudioStream):
	_sounds[id] = audio
	
func get_audio_by_id(id: String):
	return _sounds.get(id)

func _ready() -> void:
	register_sound("BREAK_DIRT", load("res://Assets/Audio/FX/Break/break_dirt.wav"))
	register_sound("BREAK_LEAVES", load("res://Assets/Audio/FX/Break/break_leaves.wav"))
	register_sound("WALK_DIRT", load("res://Assets/Audio/FX/Walk/walk_dirt.wav"))
