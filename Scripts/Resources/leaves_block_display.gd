class_name LeavesBlockDisplay
extends ShadedBlockDisplay

func update_material(pos: Vector2i, mat: Material):
	var blockstate: LeavesBlockState = GameData.map.get_cell(pos.x, pos.y).block_state
	var smat: ShaderMaterial = mat
	smat.set_shader_parameter("value", blockstate.infected)
