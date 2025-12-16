class_name CraftTableBlockState
extends BlockState

func get_id() -> String:
	return "CRAFT_TABLE"

func instanciate(_pos: Vector2i):
	return CraftTableBlockState.new()

func on_use(_pos: Vector2i):
	GameData.game_manager.hud.craft_table_menu.visible = true
	GameData.game_manager.hud.menu_toggled.emit(true)
