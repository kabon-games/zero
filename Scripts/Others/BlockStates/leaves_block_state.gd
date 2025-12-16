class_name LeavesBlockState
extends BlockState

var infected: float = -1

func is_leave(block: BlockData) -> bool:
	if block == Blocks.TREE_LEAVES_0:
		return true
	if block == Blocks.TREE_LEAVES_1:
		return true
	if block == Blocks.TREE_LEAVES_2:
		return true
	if block == Blocks.TREE_LEAVES_3:
		return true
	if block == Blocks.TREE_LEAVES_4:
		return true
	if block == Blocks.TREE_LEAVES_5:
		return true
	if block == Blocks.TREE_LEAVES_6:
		return true
	if block == Blocks.TREE_LEAVES_7:
		return true
	if block == Blocks.TREE_LEAVES_8:
		return true
	return false

func get_id() -> String:
	return "LEAVES"

func instanciate(_pos: Vector2i):
	return LeavesBlockState.new()

func process(dt: float, pos: Vector2i):
	if infected >= 0:
		if infected < 1.0:
			infected += dt / 10
			dirty = true
		
		var l = pos + Vector2i.LEFT
		var r = pos + Vector2i.RIGHT
		var u = pos + Vector2i.UP
		var d = pos + Vector2i.DOWN
		
		var lc = GameData.map.get_cell(l.x, l.y)
		var rc = GameData.map.get_cell(r.x, r.y)
		var uc = GameData.map.get_cell(u.x, u.y)
		var dc = GameData.map.get_cell(d.x, d.y)
		
		if is_leave(lc.block):
			var state: LeavesBlockState = lc.block_state
			if state.infected < 0:
				state.infected = 0
		
		if is_leave(rc.block):
			var state: LeavesBlockState = rc.block_state
			if state.infected < 0:
				state.infected = 0
		
		if is_leave(uc.block):
			var state: LeavesBlockState = uc.block_state
			if state.infected < 0:
				state.infected = 0
			
		if is_leave(dc.block):
			var state: LeavesBlockState = dc.block_state
			if state.infected < 0:
				state.infected = 0
