class_name TreeRootBlockState
extends BlockState

var timer: float = 10

func get_id() -> String:
	return "TREE_ROOT"

func instanciate(_pos: Vector2i):
	return TreeRootBlockState.new()

func on_break(pos: Vector2i):
	var direction = Utils.get_direction_from_pos(pos)
	var i = 1
	while GameData.map.get_cell(pos.x + i * direction.x, pos.y + i * direction.y).block == Blocks.TREE_TRUNK_BLOCK:
		GameData.map.put_block(pos.x + i * direction.x, pos.y + i * direction.y, null)
		i += 1
	var tree_len = i
	var x = pos.x + tree_len * direction.x
	var y = pos.y + tree_len * direction.y
	
	# check if leaves are infected, if so, drop silk
	var leave_cell = GameData.map.get_cell(x,y)
	var leave_state: LeavesBlockState = leave_cell.block_state
	if leave_state.infected >= 1:
		GameData.game_manager.map.drop_item(Vector2i(x,y), ItemStack.create(Items.THREAD_ITEM, randi_range(3,10), null))
	
	GameData.map.put_block(x + direction.x * 2, y + direction.y * 2, null)
	GameData.map.put_block(x + direction.x, y + direction.y, null)
	GameData.map.put_block(x, y, null)
	var backward = Utils.rotate_direction_backward(direction)
	var forward = Utils.rotate_direction_forward(direction)
	var leaves_x = x + backward.x
	var leaves_y = y + backward.y
	GameData.map.put_block(leaves_x, leaves_y, null)
	leaves_x += direction.x
	leaves_y += direction.y
	GameData.map.put_block(leaves_x, leaves_y, null)
	leaves_x += direction.x
	leaves_y += direction.y
	GameData.map.put_block(leaves_x, leaves_y, null)
	leaves_x = x + forward.x
	leaves_y = y + forward.y
	GameData.map.put_block(leaves_x, leaves_y, null)
	leaves_x += direction.x
	leaves_y += direction.y
	GameData.map.put_block(leaves_x, leaves_y, null)
	leaves_x += direction.x
	leaves_y += direction.y
	GameData.map.put_block(leaves_x, leaves_y, null)
