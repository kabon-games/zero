class_name SingleDropData
extends DropData

@export var item: ItemData = null
@export var quantity: int = 1

func drop() -> Array[ItemStack]:
	var item_stack: ItemStack = ItemStack.new()
	item_stack.item = item
	item_stack.quantity = quantity
	return [item_stack]
	
