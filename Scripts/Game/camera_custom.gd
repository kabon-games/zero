extends Camera2D

@export var cvp: SubViewport = null

func _init() -> void:
	self.custom_viewport = cvp
