class_name BlockDisplay
extends Resource

enum Rotation {UP, LEFT, RIGHT, DOWN}

func get_sprite(_pos: Vector2i) -> Texture2D:
	return null
	
func get_rotation(_pos: Vector2i) -> Rotation:
	return Rotation.UP
	
func get_emission(_pos: Vector2i) -> int:
	return 0

func get_collider(_pos: Vector2i) -> Vector4i:
	return Vector4i(0,0,0,0)

func get_occlusion(_pos: Vector2i) -> bool:
	return true
	
func get_shader_material(_pos: Vector2i, _current: Material) -> Material:
		return null

func update_material(_pos: Vector2i, _material: Material):
	pass
