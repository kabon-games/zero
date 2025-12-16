class_name ItemData
extends Resource

@export var uid: String = ""
@export var sprite: Texture2D
@export var stack: int = 200
@export var state: String = "DEFAULT"

func use(_pos: Vector2i, _cell: GameData.Cell, _inventory: Inventory):
	pass
	
func use_break(_pos: Vector2i, cell: GameData.Cell, _inventory: Inventory):
	if cell.block:
		if cell.block.break_level == BlockData.BreakLevel.HAND:
			if cell.block_state:
				cell.block_state.damage(cell.block, 1)
