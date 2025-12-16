class_name StateBlockDisplay
extends BlockDisplay

@export var displays: Array[BlockDisplay] = []

func get_sprite(pos: Vector2i) -> Texture2D:
	var cell = GameData.map.get_cell(pos.x, pos.y)
	if cell.block_state:
		return displays[cell.block_state.display_idx].get_sprite(pos)
	return displays[0].get_sprite(pos)

func get_rotation(pos: Vector2i) -> Rotation:
	var direction: Vector2i = Utils.get_direction_from_pos(pos)
	if direction == Vector2i.UP:
		return Rotation.UP
	if direction == Vector2i.LEFT:
		return Rotation.LEFT
	if direction == Vector2i.RIGHT:
		return Rotation.RIGHT
	return Rotation.DOWN

func get_emission(pos: Vector2i) -> int:
	var cell = GameData.map.get_cell(pos.x, pos.y)
	if cell.block_state:
		return displays[cell.block_state.display_idx].get_emission(pos)
	return displays[0].get_emission(pos)

func get_collider(pos: Vector2i) -> Vector4i:
	var cell = GameData.map.get_cell(pos.x, pos.y)
	if cell.block_state:
		return displays[cell.block_state.display_idx].get_collider(pos)
	return displays[0].get_collider(pos)

func get_occlusion(pos: Vector2i) -> bool:
	var cell = GameData.map.get_cell(pos.x, pos.y)
	if cell.block_state:
		return displays[cell.block_state.display_idx].get_occlusion(pos)
	return displays[0].get_occlusion(pos)
