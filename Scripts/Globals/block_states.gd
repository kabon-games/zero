extends Node

var DEFAULT_BLOCKSTATE = BlockState.new()
var SAPLING_BLOCKSTATE = SaplingBlockState.new()
var TREE_ROOT_BLOCKSTATE = TreeRootBlockState.new()
var WOOD_DOOR_BLOCKSTATE = WoodDoorBlockState.new()
var TORCH_BLOCKSTATE = TorchBlockState.new()
var BARREL_BLOCKSTATE = BarrelBlockState.new()
var CRAFT_TABLE_BLOCKSTATE = CraftTableBlockState.new()
var LEAVES_BLOCKSTATE = LeavesBlockState.new()
var SIEVE_BLOCKSTATE = SieveBlockState.new()

var blockstates: Array[BlockState] = []

func register_blockstate(blockstate: BlockState):
	blockstates.push_back(blockstate)

func get_blockstate_by_id(id: String) -> BlockState:
	for blockstate in blockstates:
		if blockstate.get_id() == id:
			return blockstate
	return null
	
func _ready() -> void:
	register_blockstate(SAPLING_BLOCKSTATE)
	register_blockstate(DEFAULT_BLOCKSTATE)
	register_blockstate(TREE_ROOT_BLOCKSTATE)
	register_blockstate(WOOD_DOOR_BLOCKSTATE)
	register_blockstate(TORCH_BLOCKSTATE)
	register_blockstate(BARREL_BLOCKSTATE)
	register_blockstate(CRAFT_TABLE_BLOCKSTATE)
	register_blockstate(LEAVES_BLOCKSTATE)
	register_blockstate(SIEVE_BLOCKSTATE)
