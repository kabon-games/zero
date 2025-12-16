class_name TorchBlockState
extends BlockState

func get_id() -> String:
	return "TORCH"

func instanciate(_pos: Vector2i):
	return TorchBlockState.new()
