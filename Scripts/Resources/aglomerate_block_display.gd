class_name AglomerateBlockDisplay
extends BlockDisplay

@export var atlas: Texture2D = null
@export var occluder: bool = true
@export var collider: Vector4i = Vector4i(0,0,16,16)
@export var emission: int = 0
@export var single_region:  = Vector2i(3,0)
@export var l_region: Vector2i = Vector2i(0,1)
@export var t_region: Vector2i = Vector2i(1,0)
@export var b_region: Vector2i = Vector2i(1,2)
@export var r_region: Vector2i = Vector2i(2,1)
@export var tl_region: Vector2i = Vector2i(0,0)
@export var tr_region: Vector2i = Vector2i(2,0)
@export var bl_region: Vector2i = Vector2i(0,2)
@export var br_region: Vector2i = Vector2i(2,2)
@export var center_region: Vector2i = Vector2i(1,1)

func get_sprite(_pos: Vector2i) -> Texture2D:
	var atlas_texture: AtlasTexture = AtlasTexture.new()
	atlas_texture.atlas = atlas
	atlas_texture.region = Rect2(3 * 16, 0, 16, 16)
	return atlas_texture

func _cell(pos: Vector2i, dx: int, dy: int) -> int:
	var cell = GameData.map.get_cell(pos.x + dx, pos.y + dy)
	var current = GameData.map.get_cell(pos.x, pos.y)
	return 1 if cell.block == current.block else 0
	
func get_sprite_region(pos: Vector2i) -> Vector2i:
	var model = [
		_cell(pos, -1, -1), _cell(pos, 0, -1), _cell(pos, 1, -1),
		_cell(pos, -1, 0), 1, _cell(pos, 1, 0),
		_cell(pos, -1, 1), _cell(pos, 0, 1), _cell(pos, 1, 1)
	]
	var template = [0,1,1,
	 				0,1,1,
	 				0,1,1]
	if model == template:
		return l_region
		
	template = [1,1,0,
	 			1,1,0,
	 			1,1,0]
	if model == template:
		return r_region
		
	template = [1,1,1,
	 			1,1,1,
	 			0,0,0]
	if model == template:
		return b_region
	
	template = [0,0,0,
	 			1,1,1,
	 			1,1,1]
	if model == template:
		return t_region
		
	template = [0,0,0,
	 			0,1,1,
	 			0,1,1]
	if model == template:
		return tl_region
		
	template = [0,0,0,
	 			1,1,0,
	 			1,1,0]
	if model == template:
		return tr_region
		
	template = [0,1,1,
	 			0,1,1,
	 			0,0,0]
	if model == template:
		return bl_region
	
	template = [1,1,0,
	 			1,1,0,
	 			0,0,0]
	if model == template:
		return br_region
	
	template = [1,1,1,
				1,1,1,
				1,1,1]
	if model == template:
		return center_region
	
	return single_region
	
func get_emission(_pos: Vector2i) -> int:
	return emission

func get_collider(_pos: Vector2i) -> Vector4i:
	return collider

func get_occlusion(_pos: Vector2i) -> bool:
	return occluder
