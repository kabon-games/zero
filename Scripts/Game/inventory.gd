class_name Inventory
extends Object

const NB_SLOTS: int = 10

signal slot_updated(idx: int, stack: ItemStack)
signal slot_selected(idx: int)
	
var slots: Array[ItemStack] = []
var _selected: int = 0

func generate_default_inventory():
	clear()
	update_slot(0, ItemStack.create(Items.TREE_SEED_ITEM, 5, null))
	update_slot(9, ItemStack.create(Items.WOOD_AXE_ITEM, 1, null))
	update_slot(1, ItemStack.create(Items.BACKPACK_ITEM, 1, null))

func get_item_quantity(item: ItemData) -> int:
	var quantity: int = 0
	for slot_idx in range(NB_SLOTS):
		var slot = slots[slot_idx]
		if not slot:
			continue
		if slot.item == item:
			quantity += slot.quantity
	return quantity

func clear():
	for idx in range(NB_SLOTS):
		update_slot(idx, null)

func select_slot(idx: int):
	_selected = idx
	slot_selected.emit(idx)
	
func select_next_slot():
	_selected += 1
	if _selected >= NB_SLOTS:
		_selected = 0
	select_slot(_selected)

func select_previous_slot():
	_selected -= 1
	if _selected < 0:
		_selected = NB_SLOTS - 1
	select_slot(_selected)
	
func get_selected_item() -> ItemData:
	var slot = slots[_selected]
	return slot.item if slot else null

func get_selected_slot() -> ItemStack:
	return slots[_selected]
	
func get_selected() -> int:
	return _selected

func consume(nb: int = 1):
	var slot = slots[_selected]
	slot.consume(nb)
	slot_updated.emit(_selected, slot)

func remove(item_stack: ItemStack):
	var quantity: int = item_stack.quantity
	for idx in range(NB_SLOTS):
		var slot = slots[idx]
		if slot.item == item_stack.item:
			slot.quantity -= quantity
			if slot.quantity <= 0:
				quantity += slot.quantity
				slot.quantity = 0
				slot.item = null
				slot_updated.emit(idx, null,)
				return
			else:
				slot_updated.emit(idx, slot)
				return
		
func try_grab(stack: ItemStack) -> Vector2i :
	if stack.quantity <= 0:
		return Vector2i(0, -1)
	for idx in range(NB_SLOTS):
		var slot: ItemStack = slots[idx]
		if slot and slot.item == stack.item and slot.quantity != stack.item.stack:
			var remaining_space: int = stack.item.stack - slot.quantity
			if remaining_space >= stack.quantity:
				update_slot(idx,ItemStack.create(stack.item, slot.quantity + stack.quantity, slot.item_state))
				return Vector2i(0, idx)
			elif remaining_space != stack.item.stack:
				update_slot(idx, ItemStack.create(stack.item, stack.item.stack, slot.item_state))
				return Vector2i(stack.quantity - remaining_space, idx)
	for idx in range(NB_SLOTS):
		var slot: ItemStack = slots[idx]
		if not slot or slot.item == null:
			update_slot(idx, stack)
			return Vector2i(0, idx)
	return Vector2i(stack.quantity, -1)

func update_slot(idx: int, stack: ItemStack):
	slots[idx] = stack
	slot_updated.emit(idx, stack)

func _init() -> void:
	for idx in range(NB_SLOTS):
		var item_stack: ItemStack = ItemStack.new()
		item_stack.item = null
		item_stack.quantity = 0
		slots.append(item_stack)
