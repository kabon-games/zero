class_name PickaxeItemData
extends ItemData

@export var break_level: BlockData.BreakLevel = BlockData.BreakLevel.WOOD

func use(pos: Vector2i, cell: GameData.Cell, inventory: Inventory):
	use_break(pos, cell, inventory)

func use_break(_pos: Vector2i, cell: GameData.Cell, _inventory: Inventory):
	if cell.block:
		if cell.block.break_level <= break_level and (cell.block.tool_break == BlockData.ToolBreak.AXE or cell.block.tool_break == BlockData.ToolBreak.NONE):
			if cell.block_state:
				cell.block_state.damage(cell.block, break_level)
