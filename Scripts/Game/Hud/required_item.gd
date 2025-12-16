class_name RequiredItem
extends Control

var item_sprite: TextureRect = null
var quantity_label: Label = null

func _ready() -> void:
	item_sprite = get_node("VBoxContainer/Item")
	quantity_label = get_node("VBoxContainer/Quantity")
	
func set_stack(stack: ItemStack):
	item_sprite = get_node("VBoxContainer/Item")
	quantity_label = get_node("VBoxContainer/Quantity")
	
	item_sprite.texture = stack.item.sprite
	quantity_label.text = str(stack.quantity)
