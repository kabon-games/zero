extends Node

var map: MapData = MapData.new()
var game_manager: GameManager = null

signal gamedata_updated

@rpc("authority", "call_local")
func _send_cell(x: int, y: int, block: String, _backblock: String):
	var block_data: BlockData = Blocks.get_block_by_id(block)
	self.map.put_block(x,y, block_data)
	
@rpc("authority", "call_local")
func _gamedata_updated():
	gamedata_updated.emit()

@rpc("any_peer","call_local")
func receive_data(request_id: int):
	if not multiplayer.is_server():
		return
	for cell in map.get_cells():
		self.map.put_block(cell.x,cell.y, cell.block)
	_gamedata_updated.rpc_id(request_id)

@rpc("authority", "call_local")
func _put_fluid(pos: Vector2i, fluid: String, quantity: float):
	var fluid_data: FluidData = Fluids.get_fluid_by_id(fluid)
	var cell = map.get_cell(pos.x,pos.y)
	if fluid_data:
		cell.fluid = fluid_data
		cell.fluid_quantity = quantity
	else:
		cell.fluid = null
		cell.fluid_quantity = 0
	map.updated_block.emit(pos, "")
	
@rpc("authority", "call_local")
func _put_block(pos: Vector2i, block: String, sound: String):
	var blockdata: BlockData = Blocks.get_block_by_id(block)
	var cell = map.get_cell(pos.x,pos.y)
	if blockdata and blockdata.is_background:
		cell.backblock = blockdata
		if cell.backblock:
			var state: BlockState = BlockStates.get_blockstate_by_id(cell.backblock.block_state_id)
			cell.backblock_state = state.instanciate(pos) if state else null
		else:
			cell.backblock_state = null
	else:
		cell.block = blockdata
		if cell.block:
			if cell.block.display.get_collider(pos) != Vector4i.ZERO:
				cell.fluid_quantity = 0
				cell.fluid = null
			var state: BlockState = BlockStates.get_blockstate_by_id(cell.block.block_state_id)
			cell.block_state = state.instanciate(pos) if state else null
		else:
			cell.block_state = null
	map.updated_block.emit(Vector2i(pos.x,pos.y), sound)

class MapData:
	signal updated_block(pos: Vector2i, sound: String)
	
	var _cells: Array[Cell] = []
	
	func clear():
		_cells.clear()
	
	func get_cell(x: int, y: int) -> Cell:
		for cell in _cells:
			if cell.x == x and cell.y == y:
				return cell
		var new_cell = Cell.new()
		new_cell.x = x
		new_cell.y = y
		_cells.push_back(new_cell)
		return new_cell
	
	func put_fluid(pos: Vector2i, fluid: FluidData, quantity: float):
		if not GameData.multiplayer.is_server():
			return
		var fluid_id = fluid.uid if fluid else ""
		GameData._put_fluid.rpc(pos, fluid_id, quantity)
	
	func put_block(x: int, y: int, block: BlockData, sound: String = ""):
		if not GameData.multiplayer.is_server():
			return
		var block_id = block.uid if block else ""
		GameData._put_block.rpc(Vector2i(x,y), block_id, sound)
		
	func get_cells() -> Array[Cell]:
		return _cells
		
	func generate_map():
		for x in range(-30, 30):
			for y in range(-30, 30):
				var dist = Vector2i(x,y).distance_to(Vector2i.ZERO)
				if dist < 15:
					put_block(x,y,Blocks.DIRT_BLOCK)
		
		for x in range(-10, 10):
			for y in range(-10, 10):
				var dist = Vector2i(x,y).distance_to(Vector2i.ZERO)
				if dist < 4:
					put_block(x,y,Blocks.BEDROCK_BLOCK)
	
class Cell:
	var x = 0
	var y = 0
	var block: BlockData = null
	var block_state: BlockState = null
	var backblock: BlockData = null
	var backblock_state: BlockState = null
	var fluid: FluidData = null
	var fluid_quantity: float = 0
