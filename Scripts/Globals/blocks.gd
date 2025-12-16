extends Node

var DIRT_BLOCK: BlockData = load("res://Resources/BlockData/dirt_block.tres")
var BEDROCK_BLOCK: BlockData = load("res://Resources/BlockData/bedrock_block.tres")
var SAPLING_BLOCK: BlockData = load("res://Resources/BlockData/sapling_block.tres")
var TREE_ROOT_BLOCK: BlockData = load("res://Resources/BlockData/tree_root_block.tres")
var TREE_TRUNK_BLOCK: BlockData = load("res://Resources/BlockData/tree_trunk_block.tres")
var TREE_LEAVES_0: BlockData = load("res://Resources/BlockData/tree_leaves_0_block.tres")
var TREE_LEAVES_1: BlockData = load("res://Resources/BlockData/tree_leaves_1_block.tres")
var TREE_LEAVES_2: BlockData = load("res://Resources/BlockData/tree_leaves_2_block.tres")
var TREE_LEAVES_3: BlockData = load("res://Resources/BlockData/tree_leaves_3_block.tres")
var TREE_LEAVES_4: BlockData = load("res://Resources/BlockData/tree_leaves_4_block.tres")
var TREE_LEAVES_5: BlockData = load("res://Resources/BlockData/tree_leaves_5_block.tres")
var TREE_LEAVES_6: BlockData = load("res://Resources/BlockData/tree_leaves_6_block.tres")
var TREE_LEAVES_7: BlockData = load("res://Resources/BlockData/tree_leaves_7_block.tres")
var TREE_LEAVES_8: BlockData = load("res://Resources/BlockData/tree_leaves_8_block.tres")
var WOOD_BLOCK: BlockData = load("res://Resources/BlockData/wood_block.tres")
var CRAFT_TABLE_BLOCK: BlockData = load("res://Resources/BlockData/craft_table_block.tres")
var WOOD_DOOR_BLOCK: BlockData = load("res://Resources/BlockData/wood_door_block.tres")
var TORCH_BLOCK: BlockData = load("res://Resources/BlockData/torch_block.tres")
var WOOD_WALL_BLOCK: BlockData = load("res://Resources/BlockData/wood_wall_block.tres")
var BARREL_BLOCK: BlockData = load("res://Resources/BlockData/barrel_block.tres")
var SIEVE_BLOCK: BlockData = load("res://Resources/BlockData/sieve_block.tres")

var blocks: Array[BlockData] = []

func register_block(block: BlockData):
	blocks.push_back(block)
	
func get_block_by_id(id: String) -> BlockData:
	for block in blocks:
		if block.uid == id:
			return block
	return null
	
func _ready() -> void:
	register_block(DIRT_BLOCK)
	register_block(BEDROCK_BLOCK)
	register_block(SAPLING_BLOCK)
	register_block(TREE_ROOT_BLOCK)
	register_block(TREE_TRUNK_BLOCK)
	register_block(TREE_LEAVES_0)
	register_block(TREE_LEAVES_1)
	register_block(TREE_LEAVES_2)
	register_block(TREE_LEAVES_3)
	register_block(TREE_LEAVES_4)
	register_block(TREE_LEAVES_5)
	register_block(TREE_LEAVES_6)
	register_block(TREE_LEAVES_7)
	register_block(TREE_LEAVES_8)
	register_block(WOOD_BLOCK)
	register_block(CRAFT_TABLE_BLOCK)
	register_block(WOOD_DOOR_BLOCK)
	register_block(TORCH_BLOCK)
	register_block(WOOD_WALL_BLOCK)
	register_block(BARREL_BLOCK)
	register_block(SIEVE_BLOCK)
