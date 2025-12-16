class_name ItemState
extends Object

func get_id() -> String:
	return "DEFAULT"

func instanciate():
	return ItemState.new()

static func decode_state(value: Dictionary) -> ItemState:
	var type: String = value["uid"]
	var state = ItemStates.get_item_state_by_id(type)
	return state.decode(value)

func decode(_value: Dictionary) -> ItemState:
	return self

func encode() -> Dictionary:
	var state: Dictionary = {uid = get_id()}
	return state
	
func compare(_state: ItemState) -> bool:
	return true
