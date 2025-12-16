extends Node

var DEFAULT_ITEMSTATE = ItemState.new()
var BACKPACK_ITEMSTATE = BackpackItemState.new()

var item_states: Array[ItemState] = []

func register_item_state(state: ItemState):
	item_states.append(state)

func get_item_state_by_id(id: String):
	for state in item_states:
		if state.get_id() == id:
			return state.instanciate()
	return DEFAULT_ITEMSTATE.instanciate()

func _ready() -> void:
	register_item_state(DEFAULT_ITEMSTATE)
	register_item_state(BACKPACK_ITEMSTATE)
