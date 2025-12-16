class_name ItemStack
extends Resource

@export var item: ItemData = null
@export var quantity: int = 0
var item_state: ItemState = null

static func create(itm: ItemData, nb: int, state: ItemState) -> ItemStack:
	var stack: ItemStack = ItemStack.new()
	stack.item = itm
	stack.quantity = nb
	stack.item_state = state if state else ItemStates.get_item_state_by_id(itm.state)
	return stack

func consume(nb: int = 1):
	quantity -= nb
	if (quantity <= 0):
		quantity = 0
		item = null
