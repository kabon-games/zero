class_name SilkWormItemData
extends ItemData

func is_leave(block: BlockData) -> bool:
	if block == Blocks.TREE_LEAVES_0:
		return true
	if block == Blocks.TREE_LEAVES_1:
		return true
	if block == Blocks.TREE_LEAVES_2:
		return true
	if block == Blocks.TREE_LEAVES_3:
		return true
	if block == Blocks.TREE_LEAVES_4:
		return true
	if block == Blocks.TREE_LEAVES_5:
		return true
	if block == Blocks.TREE_LEAVES_6:
		return true
	if block == Blocks.TREE_LEAVES_7:
		return true
	if block == Blocks.TREE_LEAVES_8:
		return true
	return false

func use(_pos: Vector2i, cell: GameData.Cell, inventory: Inventory):
	if is_leave(cell.block):
		var ste: LeavesBlockState = cell.block_state
		if ste.infected < 0:
			ste.infected = 0
			inventory.consume()
			
