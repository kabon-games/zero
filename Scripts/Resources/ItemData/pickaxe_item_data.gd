class_name AxeItemData
extends ItemData

@export var break_level: BlockData.BreakLevel = BlockData.BreakLevel.WOOD

func use(pos: Vector2i, cell: GameData.Cell, inventory: Inventory):
	use_break(pos, cell, inventory)

func use_break(_pos: Vector2i, cell: GameData.Cell, _inventory: Inventory):
	if cell.block:
		if cell.block.break_level <= break_level and cell.block.tool_break == BlockData.ToolBreak.PICKAXE:
			if cell.block_state:
				cell.block_state.damage(cell.block, break_level)
