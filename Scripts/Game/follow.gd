extends Node2D

@export var target: Node2D = null

func _process(_delta: float) -> void:
	global_position = target.global_position
