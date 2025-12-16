class_name BackPackItemData
extends ItemData

func use(_pos: Vector2i, _cell: GameData.Cell, inventory: Inventory):
	var stck: ItemStack = inventory.get_selected_slot()
	var ste: BackpackItemState = stck.item_state
	GameData.game_manager.hud.back_pack_menu.display(ste, inventory)
