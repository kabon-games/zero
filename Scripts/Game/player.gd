class_name Player
extends CharacterBody2D

## Signal emited when a block is selected
signal select_block(pos: Vector2i)

## The player initial speed
@export var speed: float = 10
## The player jump strength
@export var jump_strength: float = 30
## The grabity strength that affect the player
@export var gravity_strength: float = 30

## Devices
enum Device {MOUSE, CONTROLLER}

## The player sprite
var sprite: AnimatedSprite2D = null
## The cursor sprite
var cursor_sprite: Sprite2D = null
## The audio player for when they're walking
var walk_audio_player: AudioStreamPlayer2D = null
## The sprite to display the held item
var held_item_sprite: Sprite2D = null
var fluid_particles: GPUParticles2D = null

## The player's inventory
var inventory: Inventory = Inventory.new()

## The currently used device to play
var used_device: Device = Device.MOUSE
## The current mouse position
var mouse_pos: Vector2 = Vector2.ZERO
## The current cursor position
var cursor_pos: Vector2 = Vector2.RIGHT
## The cursor position relative to the player pos
var cursor_center: Vector2 = Vector2(0, -5)

## The force applied to the player when they move right or left
var force: Vector2 = Vector2(0,1)
## The direction the player is running, -1 for left, 1 for right, 0 to idle
var run_direction: int = 0
## The velocity at which the player is falling (or jumping)
var gravity_velocity: float = 0
## The direction of the gravity
var gravity_direction: Vector2 = Vector2.DOWN

## Is a menu open ? if yes controls are disabled
var menu_is_open: bool = false

func toggle_menu(is_open: bool):
	menu_is_open = is_open

func _animate():
	if run_direction != 0:
		sprite.play("run")
		if run_direction < 0:
			sprite.flip_h = false
			held_item_sprite.position.x = 4
			held_item_sprite.flip_h = false
		else:
			sprite.flip_h = true
			held_item_sprite.position.x = -4
			held_item_sprite.flip_h = true
		
		if is_on_floor() and not walk_audio_player.playing:
			var floor_direction = get_floor_normal()
			var pos = global_position / 16.0 - floor_direction
			var floor_cell = GameData.map.get_cell(int(pos.x), int(pos.y))
			if floor_cell.block:
				var sound = Sounds.get_audio_by_id(floor_cell.block.walk_sound_id)
				walk_audio_player.stream = sound
				walk_audio_player.pitch_scale = randf_range(0.5, 1.5)
				walk_audio_player.play()
		
	else:
		sprite.play("idle")
	
	var block_pos = Vector2i(int(global_position.x / 16.0), int(global_position.y / 16.0))
	var cell = GameData.map.get_cell(block_pos.x, block_pos.y)
	if cell.fluid_quantity > 0.2 and cell.fluid_quantity < 1.0:
		fluid_particles.emitting = true
	
	cursor_sprite.position = cursor_center + (cursor_pos * 16)
	select_block.emit(get_selected_block())
	
func get_selected_block() -> Vector2:
	var dx = 0 if cursor_sprite.global_position.x < 0 else -16
	var dy = 0 if cursor_sprite.global_position.y < 0 else -16
	var cursor_block_pos = (cursor_sprite.global_position - Vector2(dx, dy)) / 16
	return cursor_block_pos

func _ready() -> void:
	sprite = get_node("sprite")
	cursor_sprite = get_node("cursor")
	walk_audio_player = get_node("WalkAudio")
	held_item_sprite = get_node("HeldItem")
	fluid_particles = get_node("FluidParticles")
	
func _update_gravity():
	var gravity: Vector2 = Vector2.DOWN
	var angle: float = gravity.angle_to(self.position)
	force = Vector2(cos(angle), sin(angle))
	global_rotation = (-1 * gravity).angle_to(self.position)
	var gravity_angle: float = Vector2.RIGHT.angle_to(self.position)
	gravity_direction = Vector2(-cos(gravity_angle), -sin(gravity_angle))
	up_direction = -gravity_direction

@rpc("authority", "call_local")
func update_inventory(idx: int, item_id: String, quantity: int, state: String):
	var state_dict = JSON.parse_string(state)
	inventory.update_slot(idx, ItemStack.create(Items.get_item_by_id(item_id), quantity, ItemState.decode_state(state_dict)))
	

@rpc("any_peer", "call_local")
func _set_run_direction(direction: int):
	run_direction = direction

@rpc("any_peer", "call_local")
func _use_item(cell_pos: Vector2i, item_slot: int):
	var slot = inventory.slots[item_slot]
	var item = slot.item if slot else null
	if item:
		item.use(cell_pos, GameData.map.get_cell(cell_pos.x, cell_pos.y), inventory)

@rpc("any_peer","call_local")
func _use_break_item(cell_pos: Vector2i, item_slot: int):
	var slot = inventory.slots[item_slot]
	var item = slot.item if slot else null
	if item:
		item.use_break(cell_pos, GameData.map.get_cell(cell_pos.x, cell_pos.y), inventory)
	else:
		var block = GameData.map.get_cell(cell_pos.x, cell_pos.y)
		if block.block and block.block.break_level == BlockData.BreakLevel.HAND:
			if block.block_state:
				block.block_state.damage(block.block, 1)
	

func _controls():
	if menu_is_open:
		return
	
	if (Input.is_action_pressed("left")):
		run_direction = 1
	elif (Input.is_action_pressed("right")):
		run_direction = -1
	else:
		run_direction = 0
	_set_run_direction.rpc(run_direction)
	if (Input.is_action_just_pressed("jump")):
		_jump.rpc_id(1)
	
	if mouse_pos != get_viewport().get_mouse_position():
		used_device = Device.MOUSE
	
	if 	Input.get_axis("cursor_left", "cursor_right") != 0 || Input.get_axis("cursor_down", "cursor_up"):
		used_device = Device.CONTROLLER
	
	mouse_pos = get_viewport().get_mouse_position()
	if (used_device == Device.MOUSE):
		var mouse_cell = mouse_pos - get_viewport_rect().end / 2
		var mouse_angle = Vector2.RIGHT.angle_to(mouse_cell)
		cursor_pos = Vector2(cos(mouse_angle), sin(mouse_angle))
	elif used_device == Device.CONTROLLER:
		var horizontal_axis = Input.get_axis("cursor_left", "cursor_right")
		var vertical_axis = Input.get_axis("cursor_up", "cursor_down")
		cursor_pos = Vector2(horizontal_axis, vertical_axis)
	
	if (Input.is_action_just_pressed("use")):
		_use_item.rpc_id(1, get_selected_block(), inventory.get_selected())
		
	
	if (Input.is_action_pressed("break")):
		_use_break_item.rpc_id(1, get_selected_block(), inventory.get_selected())
	
	if (Input.is_action_pressed("drop")):
		pass
	
	if (Input.is_action_just_pressed("item_next")):
		inventory.select_next_slot()
		var selected = inventory.get_selected_item()
		held_item_sprite.texture = selected.sprite if selected else null
	
	if (Input.is_action_just_pressed("item_previous")):
		inventory.select_previous_slot()
		var selected = inventory.get_selected_item()
		held_item_sprite.texture = selected.sprite if selected else null
		
	if (Input.is_action_just_pressed("use_map")):
		var cell_pos = get_selected_block()
		var cell = GameData.map.get_cell(cell_pos.x, cell_pos.y)
		if cell.block_state:
			cell.block_state.on_use(cell_pos)
	
@rpc("any_peer", "call_local")
func _jump():
	var pos = Vector2i(int(global_position.x / 16.0), int(global_position.y / 16.0))
	var cell = GameData.map.get_cell(pos.x, pos.y)
	
	if is_on_floor() or cell.fluid_quantity >= 0.9:
		gravity_velocity = jump_strength

func _apply_physics():	
	var pos = Vector2i(int(global_position.x / 16.0), int(global_position.y / 16.0))
	var cell = GameData.map.get_cell(pos.x, pos.y)
	var speed_mul = 1.0 if cell.fluid_quantity < 0.5 else 0.2
	
	gravity_velocity -= gravity_strength
	if gravity_strength < -gravity_strength:
		gravity_strength = -gravity_strength
		
	# apply gravity
	if is_on_floor():
		self.velocity = run_direction * get_floor_normal().rotated(deg_to_rad(-90)) * speed * speed_mul
	else:
		self.velocity = run_direction * speed * force * speed_mul
	if not is_on_floor() or gravity_velocity > 0:
		self.velocity -= gravity_direction * gravity_velocity * speed_mul
	else:
		gravity_velocity = 0
	move_and_slide()

@rpc("authority", "call_local")
func _update_position(x: float, y: float):
	global_position = Vector2(x,y)

func _process(_delta: float) -> void:
	if (id == Network.me):
		_controls()
	if multiplayer.is_server():
		_apply_physics()
		_update_position.rpc(global_position.x, global_position.y)
		
	_animate()
	_update_gravity()

var id: int = -1
