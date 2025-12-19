extends Node

var DIRT_ITEM: ItemData = load("res://Resources/ItemData/dirt_item.tres")
var BEDROCK_ITEM: ItemData = load("res://Resources/ItemData/bedrock_item.tres")
var TREE_SEED_ITEM: ItemData = load("res://Resources/ItemData/tree_seed_item.tres")
var WOOD_ITEM: ItemData = load("res://Resources/ItemData/wood_item.tres")
var WOOD_PICKAXE_ITEM: ItemData = load("res://Resources/ItemData/wood_pickaxe_item.tres")
var WOOD_SHOVEL_ITEM: ItemData = load("res://Resources/ItemData/wood_shovel_item.tres")
var WOOD_AXE_ITEM: ItemData = load("res://Resources/ItemData/wood_axe_item.tres")
var CRAFT_TABLE_ITEM: ItemData = load("res://Resources/ItemData/craft_table_item.tres")
var WOOD_DOOR_ITEM: ItemData = load("res://Resources/ItemData/wood_door_item.tres")
var TORCH_ITEM: ItemData = load("res://Resources/ItemData/torch_item.tres")
var WOOD_WALL_ITEM = load("res://Resources/ItemData/wood_wall_item.tres")
var BARREL_ITEM = load("res://Resources/ItemData/barrel_item.tres")
var WOOD_BUCKET_ITEM = load("res://Resources/ItemData/wood_bucket_item.tres")
var WOOD_BUCKET_WATER_ITEM = load("res://Resources/ItemData/wood_bucket_water_item.tres")
var WOOD_HOE_ITEM = load("res://Resources/ItemData/wood_hoe_item.tres")
var SILK_WORM_ITEM = load("res://Resources/ItemData/silk_worm_item.tres")
var THREAD_ITEM = load("res://Resources/ItemData/thread_item.tres")
var SIEVE_ITEM = load("res://Resources/ItemData/sieve_item.tres")
var BACKPACK_ITEM = load("res://Resources/ItemData/backpack_item.tres")
var PEBBLE_ITEM = load("res://Resources/ItemData/pebble_item.tres")
var WHEAT_SEED_ITEM = load("res://Resources/ItemData/wheat_seed_item.tres")

var items: Array[ItemData] = []

func register_item(item: ItemData):
	items.push_back(item)
	
func get_item_by_id(id: String) -> ItemData:
	for item in items:
		if item.uid == id:
			return item
	return null
	
func _ready() -> void:
	register_item(DIRT_ITEM)
	register_item(BEDROCK_ITEM)
	register_item(TREE_SEED_ITEM)
	register_item(WOOD_ITEM)
	register_item(WOOD_PICKAXE_ITEM)
	register_item(WOOD_SHOVEL_ITEM)
	register_item(WOOD_AXE_ITEM)
	register_item(CRAFT_TABLE_ITEM)
	register_item(WOOD_DOOR_ITEM)
	register_item(TORCH_ITEM)
	register_item(WOOD_WALL_ITEM)
	register_item(BARREL_ITEM)
	register_item(WOOD_BUCKET_ITEM)
	register_item(WOOD_BUCKET_WATER_ITEM)
	register_item(WOOD_HOE_ITEM)
	register_item(SILK_WORM_ITEM)
	register_item(THREAD_ITEM)
	register_item(SIEVE_ITEM)
	register_item(BACKPACK_ITEM)
	register_item(PEBBLE_ITEM)
	register_item(WHEAT_SEED_ITEM)
