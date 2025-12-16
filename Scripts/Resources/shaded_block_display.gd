class_name ShadedBlockDisplay
extends SimpleBlockDisplay

@export var material: Material = null

func get_shader_material(_pos: Vector2i, current: Material) -> Material:
		if material is ShaderMaterial:
			if current is not ShaderMaterial or material.shader != current.shader:
				return material.duplicate()
		return current
	
