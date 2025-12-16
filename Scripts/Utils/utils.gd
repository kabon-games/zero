class_name Utils
extends Object

enum TileTransform {
	ROTATE_0 = 0,
	ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}

static func rotate_direction_forward(dir: Vector2i) -> Vector2i:
	if dir == Vector2i.DOWN:
		return Vector2i.LEFT
	if dir == Vector2i.LEFT:
		return Vector2i.UP
	if dir == Vector2i.UP:
		return Vector2i.RIGHT
	return Vector2i.DOWN

static func rotate_direction_backward(dir: Vector2i) -> Vector2i:
	if dir == Vector2i.DOWN:
		return Vector2i.RIGHT
	if dir == Vector2i.LEFT:
		return Vector2i.DOWN
	if dir == Vector2i.UP:
		return Vector2i.LEFT
	return Vector2i.UP
		

static func get_direction_from_pos(pos: Vector2i) -> Vector2i:
	var direction: Vector2i = Vector2i.UP
	var angle: float = Vector2.UP.angle_to(pos)
	if angle >= -PI/4 and angle <= PI/4:
		direction = Vector2i.UP
	elif angle >= -(3*PI)/4 and angle <= -PI/4:
		direction = Vector2i.LEFT
	elif angle >= PI/4 and angle <= (3*PI)/4:
		direction = Vector2i.RIGHT
	else:
		direction = Vector2i.DOWN
	return direction
