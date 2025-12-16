class_name SaplingBlockState
extends BlockState

var timer: float = 10

func get_id() -> String:
	return "SAPLING"

func instanciate(_pos: Vector2i):
	return SaplingBlockState.new()

func generate_tree(pos: Vector2i):
	var direction = Utils.get_direction_from_pos(pos)
	var tree_len = randi_range(2, 4)
	var x = pos.x + tree_len * direction.x
	var y = pos.y + tree_len * direction.y
	var backward = Utils.rotate_direction_backward(direction)
	var forward = Utils.rotate_direction_forward(direction)
	
	# Check if the tree can spawn
	var needed: Array[Vector2i] = []
	for i in range(1, tree_len):
		needed.append(Vector2i(pos.x + i * direction.x, pos.y + i * direction.y))
	needed.append(Vector2i(x + direction.x * 2, y + direction.y * 2))
	needed.append(Vector2i(x + direction.x, y + direction.y))
	needed.append(Vector2i(x,y))
	var leaves_x = x + backward.x
	var leaves_y = y + backward.y
	needed.append(Vector2i(leaves_x, leaves_y))
	leaves_x += direction.x
	leaves_y += direction.y
	needed.append(Vector2i(leaves_x, leaves_y))
	leaves_x += direction.x
	leaves_y += direction.y
	needed.append(Vector2i(leaves_x, leaves_y))
	leaves_x = x + forward.x
	leaves_y = y + forward.y
	needed.append(Vector2i(leaves_x, leaves_y))
	leaves_x += direction.x
	leaves_y += direction.y
	needed.append(Vector2i(leaves_x, leaves_y))
	leaves_x += direction.x
	leaves_y += direction.y
	needed.append(Vector2i(leaves_x, leaves_y))
	
	for block_pos in needed:
		var cell = GameData.map.get_cell(block_pos.x, block_pos.y)
		if cell.block:
			return
	
	# Spawn the tree
	GameData.map.put_block(pos.x, pos.y, Blocks.TREE_ROOT_BLOCK)
	for i in range(1, tree_len):
		GameData.map.put_block(pos.x + i * direction.x, pos.y + i * direction.y, Blocks.TREE_TRUNK_BLOCK)
	GameData.map.put_block(x + direction.x * 2, y + direction.y * 2, Blocks.TREE_LEAVES_1)
	GameData.map.put_block(x + direction.x, y + direction.y, Blocks.TREE_LEAVES_4)
	GameData.map.put_block(x, y, Blocks.TREE_LEAVES_7)
	leaves_x = x + backward.x
	leaves_y = y + backward.y
	GameData.map.put_block(leaves_x, leaves_y, Blocks.TREE_LEAVES_6)
	leaves_x += direction.x
	leaves_y += direction.y
	GameData.map.put_block(leaves_x, leaves_y, Blocks.TREE_LEAVES_3)
	leaves_x += direction.x
	leaves_y += direction.y
	GameData.map.put_block(leaves_x, leaves_y, Blocks.TREE_LEAVES_0)
	leaves_x = x + forward.x
	leaves_y = y + forward.y
	GameData.map.put_block(leaves_x, leaves_y, Blocks.TREE_LEAVES_8)
	leaves_x += direction.x
	leaves_y += direction.y
	GameData.map.put_block(leaves_x, leaves_y, Blocks.TREE_LEAVES_5)
	leaves_x += direction.x
	leaves_y += direction.y
	GameData.map.put_block(leaves_x, leaves_y, Blocks.TREE_LEAVES_2)

func destroy_if_no_dirt(pos: Vector2i):
	var direction = Utils.get_direction_from_pos(pos)
	var cell: GameData.Cell = GameData.map.get_cell(pos.x - direction.x, pos.y - direction.y)
	var block: BlockData = cell.block
	if cell.block != Blocks.DIRT_BLOCK:
		GameData.map.put_block(pos.x, pos.y, null)
		GameData.game_manager.map.drop_item(pos, ItemStack.create(Items.TREE_SEED_ITEM, 1, null))
	
func process(dt: float, pos: Vector2i):
	timer -= dt
	
	destroy_if_no_dirt(pos)
	if timer < 0 and randf() < 0.01:
		generate_tree(pos)
