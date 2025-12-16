class_name BarrelBlockState
extends BlockState

var fill: float = 0

func get_id() -> String:
	return "BARREL"

func instanciate(_pos: Vector2i):
	return BarrelBlockState.new()

func process(dt: float, _pos: Vector2i):
	if GameData.game_manager.is_raining and fill <= 1:
			fill += dt / 10.0
			if fill >= 1 and display_idx != 1:
				display_idx = 1
				dirty = true
