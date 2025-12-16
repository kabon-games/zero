class_name SimpleBlockDisplay
extends BlockDisplay

@export var atlas: Texture2D = null
@export var occluder: bool = true
@export var collider: Vector4i = Vector4i(0,0,16,16)
@export var emission: int = 0

func get_sprite(_pos: Vector2i) -> Texture2D:
	return atlas
	
func get_rotation(pos: Vector2i) -> Rotation:
	var direction: Vector2i = Utils.get_direction_from_pos(pos)
	if direction == Vector2i.UP:
		return Rotation.UP
	if direction == Vector2i.LEFT:
		return Rotation.LEFT
	if direction == Vector2i.RIGHT:
		return Rotation.RIGHT
	return Rotation.DOWN
	
func get_emission(_pos: Vector2i) -> int:
	return emission

func get_collider(_pos: Vector2i) -> Vector4i:
	return collider

func get_occlusion(_pos: Vector2i) -> bool:
	return occluder
