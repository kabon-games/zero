class_name FluidItemData
extends ItemData

@export var fluid: FluidData = null
@export var empty_item: String = ""

func use(pos: Vector2i, cell: GameData.Cell, inventory: Inventory):
	var has_collider: bool = false
	if cell.block:
		has_collider = cell.block.display.get_collider(pos) != Vector4i.ZERO
			
	if not has_collider:
		GameData.map.put_fluid(pos, fluid, 1)
		var selected = inventory.get_selected_slot()
		inventory.remove(ItemStack.create(selected.item, 1, selected.item_state))
		var item = Items.get_item_by_id(empty_item)
		if item:
			inventory.try_grab(ItemStack.create(item, 1, null))
