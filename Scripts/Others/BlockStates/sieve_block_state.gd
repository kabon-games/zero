class_name SieveBlockState
extends BlockState

func get_id() -> String:
	return "SIEVE"

func instanciate(_pos: Vector2i):
	return SieveBlockState.new()

func on_use(_pos: Vector2i):
	GameData.game_manager.hud.craft_table_menu.visible = true
	GameData.game_manager.hud.menu_toggled.emit(true)
