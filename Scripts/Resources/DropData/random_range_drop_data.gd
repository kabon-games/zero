class_name RandomRangeDropData
extends DropData

@export var item: ItemData = null
@export var min_nb: int = 1
@export var max_nb: int = 2

func drop() -> Array[ItemStack]:
	var quantity = randi_range(min_nb, max_nb)
	var item_stack: ItemStack = ItemStack.new()
	item_stack.item = item
	item_stack.quantity = quantity
	return [item_stack]
	
