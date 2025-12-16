class_name PlaceableItemData
extends ItemData

@export var block_id: String = ""
@export var place_sound: String = ""

func use(pos: Vector2i, cell: GameData.Cell, inventory: Inventory):
	if not cell.block:
		var block: BlockData = Blocks.get_block_by_id(block_id)
		GameData.map.put_block(pos.x, pos.y, block, place_sound)
		inventory.consume()
