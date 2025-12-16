class_name MultipleDropData
extends DropData

@export var drops: Array[DropData] = []

func drop() -> Array[ItemStack]:
	var drop_list: Array[ItemStack] = []
	for drp in drops:
		drop_list.append_array(drp.drop())
	return drop_list
	
