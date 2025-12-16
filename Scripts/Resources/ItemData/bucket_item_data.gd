class_name BucketItemData
extends ItemData

@export var filled_item: ItemData = null

func use(pos: Vector2i, cell: GameData.Cell, inventory: Inventory):
	if cell.fluid_quantity >= 0.9:
		GameData.map.put_fluid(pos, null, 0)
		inventory.remove(ItemStack.create(inventory.get_selected_item(), 1, null))
		inventory.try_grab(ItemStack.create(filled_item, 1, null))
	
	if cell.block == Blocks.BARREL_BLOCK:
		var bstate: BarrelBlockState = cell.block_state
		if bstate.fill >= 1:
			bstate.fill = 0
			bstate.display_idx = 0
			bstate.dirty = true
			inventory.remove(ItemStack.create(inventory.get_selected_item(), 1, null))
		inventory.try_grab(ItemStack.create(filled_item, 1, null))
			
