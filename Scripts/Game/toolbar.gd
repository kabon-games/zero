class_name Toolbar
extends TextureRect

var empty: ImageTexture = null
var slots: Array[TextureRect] = []
var current_index: int = 0
var overrided_select = -1

func _ready() -> void:
	empty = ImageTexture.create_from_image(Image.create_empty(16,16, false, Image.FORMAT_RGBA8))
	slots.push_back(get_node("ItemBarHLayout/slot1"))
	slots.push_back(get_node("ItemBarHLayout/slot2"))
	slots.push_back(get_node("ItemBarHLayout/slot3"))
	slots.push_back(get_node("ItemBarHLayout/slot4"))
	slots.push_back(get_node("ItemBarHLayout/slot5"))
	slots.push_back(get_node("ItemBarHLayout/slot6"))
	slots.push_back(get_node("ItemBarHLayout/slot7"))
	slots.push_back(get_node("ItemBarHLayout/slot8"))
	slots.push_back(get_node("ItemBarHLayout/slot9"))
	slots.push_back(get_node("ItemBarHLayout/slot10"))
	
	for slot in slots:
		slot.texture = empty
	
	select(0)
	
func update_all(inventory: Inventory):
	for idx in range(Inventory.NB_SLOTS):
		var slot: ItemStack = inventory.slots[idx]
		update_slot(idx, slot)
	
func update_slot(idx: int, stack: ItemStack):
	if stack and stack.item and stack.quantity > 0:
		slots[idx].texture = stack.item.sprite
		slots[idx].get_child(0).text = str(stack.quantity)
	else:
		slots[idx].texture = empty
		slots[idx].get_child(0).text = ""

func select(idx: int):
	var mat: ShaderMaterial = slots[current_index].material
	mat.set_shader_parameter("active", false)
	mat = slots[idx].material
	mat.set_shader_parameter("active", true)
	current_index = idx

func unoverride_select():
	select(current_index)

func modulate(idx: int, color: Color):
	var smat: ShaderMaterial = slots[idx].material
	smat.set_shader_parameter("modulate", color)

func override_select(idx: int):
	var smat: ShaderMaterial = slots[current_index].material
	smat.set_shader_parameter("active", false)
	if overrided_select >= 0:
		var mat: ShaderMaterial = slots[overrided_select].material
		mat.set_shader_parameter("active", false)
	if idx >= 0:
		var mat: ShaderMaterial = slots[idx].material
		mat.set_shader_parameter("active", true)
	overrided_select = idx
