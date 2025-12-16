class_name WoodDoorBlockState
extends BlockState

var is_open: bool = false

func get_id() -> String:
	return "WOOD_DOOR"

func instanciate(_pos: Vector2i):
	return WoodDoorBlockState.new()

func on_use(_pos: Vector2i):
	is_open = not is_open
	display_idx = 1 if is_open else 0
	dirty = true
