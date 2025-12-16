class_name BackpackItemState
extends ItemState

const NB_SLOTS: int = 24
var slots: Array[ItemStack] = []

func _init() -> void:
	for i in NB_SLOTS:
		slots.append(null)

func get_id() -> String:
	return "BACKPACK"
	
func instanciate():
	return BackpackItemState.new()

func encode() -> Dictionary:
	var state: Dictionary = {uid = get_id()}
	var slot_json = []
	for slot in slots:
		var sl: Dictionary = {}
		if slot:
			sl = {
				item= slot.item.uid,
				quantity= slot.quantity,
				state= slot.item_state
			}
		else:
			sl = {
				item = null,
				quantity = 0,
				state = null
			}
		slot_json.append(sl)
	state.set("slots", slot_json)
	return state
	
func decode(value: Dictionary) -> ItemState:
	var slots_json: Array[Dictionary] = value["slots"]
	var i: int = 0
	for slot in slots_json:
		if slot.item == null:
			slot[i] = null
		else:
			var stack: ItemStack = ItemStack.create(slot.item, slot.quantity, ItemState.decode_state(slot.state))
			slots[i] = stack
		i += 1
	return self
	
func compare(_state: ItemState) -> bool:
	return false
