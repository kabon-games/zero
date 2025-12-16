class_name Map
extends Node2D

const DROP_ASSET: PackedScene = preload("res://Scenes/Game/drop.tscn")

var collision_layer: CollisionTileMap = null

var rain_particles: GPUParticles2D = null

var sun: DirectionalLight2D = null
var light_env: CanvasLayer = null
var occlusion_renderer: Sprite2D = null

func toggle_rain(is_raining: bool):
	rain_particles.emitting = is_raining

func update_cell_at(pos: Vector2i, sound: String = ""):
	update_cell(GameData.map.get_cell(pos.x, pos.y), sound)
	
func update_cell(cell: GameData.Cell, sound: String = "", _proc_shadows: bool = true):
	var pos: Vector2i = Vector2i(cell.x, cell.y)
	collision_layer.set_cell(pos, cell)
		
	# play sound if any
	var sound_stream: AudioStream = Sounds.get_audio_by_id(sound)
	if sound_stream:
		var sound_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		sound_player.stream = sound_stream
		add_child(sound_player)
		sound_player.global_position = pos * 16
		sound_player.pitch_scale = randf_range(0.5, 1.5)
		sound_player.play()
	

@rpc("authority", "call_local")
func _drop_item(pos: Vector2i, item_id: String, quantity: int, id: int, state: String):
	var item: ItemData = Items.get_item_by_id(item_id)
	var drop: Drop = DROP_ASSET.instantiate()
	self.add_child(drop)
	drop.name = "Drop_" + str(id)
	drop.global_position = pos * 16 - Vector2i(8,8)
	var state_dict: Dictionary = JSON.parse_string(state)
	drop.set_stack(ItemStack.create(item, quantity, ItemState.decode_state(state_dict)))

func drop_item(pos: Vector2i, stack: ItemStack):
	if not multiplayer.is_server():
		return
	var item_id: String = stack.item.uid if stack and stack.item else ""
	var state =  stack.item_state.encode() if stack.item_state else {uid="DEFAULT"}
	_drop_item.rpc(pos, item_id, stack.quantity, Drop.counter, JSON.stringify(state))
	Drop.counter += 1

func select_cell(pos: Vector2i):
	collision_layer.select(pos)

func update_all():
	for cell in GameData.map.get_cells():
		update_cell(cell, "", false)
	await get_tree().create_timer(0.1).timeout

func process_fluids(dt: float):
	var updated: Array[GameData.Cell] = []
	for cell in GameData.map.get_cells():
		if updated.has(cell):
			continue
		if cell.fluid:
			var gravity = Utils.get_direction_from_pos(Vector2i(cell.x, cell.y))
			var down_pos = Vector2i(cell.x - gravity.x, cell.y - gravity.y)
			var down = GameData.map.get_cell(down_pos.x, down_pos.y)
			var dc = down.block.display.get_collider(down_pos) if down.block else Vector4i.ZERO
			if dc == Vector4i.ZERO and down.fluid_quantity < 1.0:
				down.fluid = cell.fluid
				down.fluid_quantity += cell.fluid_quantity
				if down.fluid_quantity > 1:
					cell.fluid_quantity = down.fluid_quantity - 1
					down.fluid_quantity = 1
				else:
					cell.fluid = null
					cell.fluid_quantity = 0
				update_cell(cell)
				update_cell(down)
				updated.append(down)
			else:
				var l = Utils.rotate_direction_forward(gravity)
				var left_pos = Vector2i(cell.x - l.x, cell.y - l.y)
				var left = GameData.map.get_cell(left_pos.x, left_pos.y)
				var lc = left.block.display.get_collider(left_pos) if left.block else Vector4i.ZERO
				if lc == Vector4i.ZERO and left.fluid_quantity + dt < cell.fluid_quantity and left.fluid_quantity < 1:
					left.fluid = cell.fluid
					left.fluid_quantity += dt
					cell.fluid_quantity -= dt
					if cell.fluid_quantity <= 0.0:
						cell.fluid_quantity = 0
						cell.fluid = null
					update_cell(cell)
					update_cell(left)
					updated.append(left)
					
				var r = Utils.rotate_direction_backward(gravity)
				var right_pos = Vector2i(cell.x - r.x, cell.y - r.y)
				var right = GameData.map.get_cell(right_pos.x, right_pos.y)
				var rc = right.block.display.get_collider(right_pos) if right.block else Vector4i.ZERO
				if cell.fluid and rc == Vector4i.ZERO and right.fluid_quantity + dt < cell.fluid_quantity and right.fluid_quantity < 1:
					right.fluid = cell.fluid
					right.fluid_quantity += dt
					cell.fluid_quantity -= dt
					if cell.fluid_quantity <= 0.0:
						cell.fluid_quantity = 0
						cell.fluid = null
					update_cell(cell)
					update_cell(right)
					updated.append(right)
			updated.append(cell)

func process_blockstates(dt: float):
	for cell in GameData.map.get_cells():
		if cell.block_state:
			cell.block_state.process(dt, Vector2i(cell.x, cell.y))
			if cell.block_state and cell.block_state.is_block_dirty():
				update_cell(cell)
			if cell.block_state and cell.block_state.is_broken():
				var drops: Array[ItemStack] = cell.block.drop.drop()
				for drop in drops:
					drop_item(Vector2i(cell.x, cell.y), drop)
				cell.block_state.on_break(Vector2i(cell.x, cell.y))
				GameData.map.put_block(cell.x, cell.y, null, cell.block.break_sound_id)

func _ready() -> void:
	collision_layer = get_node("CollisionLayer")
	
	rain_particles = get_node("Rain")
	
	sun = get_node("shadow drawer/LightEnv/PointLight2D2")
	light_env = get_node("shadow drawer/LightEnv")
	var shadow_drawer: SubViewport = get_node("shadow drawer")
	shadow_drawer.world_2d = get_viewport().world_2d
	occlusion_renderer = get_node("occlusion_renderer")
	
	collision_layer.light_env = light_env
	
	update_all()
	
func _process(delta: float) -> void:
	if multiplayer.is_server():
		process_blockstates(delta)
		sun.rotate(0.03 * delta)
		process_fluids(delta)
	
