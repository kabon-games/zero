class_name CollisionTileMap
extends Node2D

const BREAK_TEXTURE = preload("res://Assets/Sprites/Tilesets/break.png")
const CELL_PREFAB = preload("res://Scenes/Game/cell.tscn")
var air: ImageTexture = null
var light_env: CanvasLayer = null

class Cell:
	var x: int = 0
	var y: int = 0
	var node: Sprite2D = null
	var break_sprite: Sprite2D = null
	var occluder: LightOccluder2D = null
	var light: PointLight2D = null
	var particle_physics: LightOccluder2D = null
	var is_selected: bool = false
	var backblock: Sprite2D = null
	var fluid: Sprite2D = null

	func select():
		node.modulate = Color(0.902, 0.98, 0.114, 1.0)
		is_selected = true
	
	func unselect():
		node.modulate = Color.WHITE
		is_selected = false
	
var cells: Array[Cell]
var selected: Cell = null

func select(pos: Vector2i):
	if selected:
		selected.unselect()
	selected = get_cell_data(pos)
	selected.select()

func get_cell_no_new(pos: Vector2i) -> Cell:
	for c in cells:
		if c.x == pos.x and c.y == pos.y:
			return c
	return null

func get_cell_data(pos: Vector2i) -> Cell:
	for c in cells:
		if c.x == pos.x and c.y == pos.y:
			return c
	var new_cell = Cell.new()
	new_cell.x = pos.x
	new_cell.y = pos.y
	new_cell.node = CELL_PREFAB.instantiate()
	new_cell.node.name = "Cell_" + str(pos.x) + "_" + str(pos.y)
	new_cell.node.texture = air
	var body: StaticBody2D = new_cell.node.get_child(0)
	body.process_mode = Node.PROCESS_MODE_DISABLED
	var body_collider: CollisionShape2D = body.get_child(0)
	body_collider.shape = body_collider.shape.duplicate()
	new_cell.node.global_position.x = pos.x * 16
	new_cell.node.global_position.y = pos.y * 16
	new_cell.break_sprite = new_cell.node.get_child(2)
	new_cell.light = new_cell.node.get_child(3)
	new_cell.occluder = new_cell.node.get_child(1)
	new_cell.particle_physics = new_cell.node.get_child(4)
	new_cell.backblock = new_cell.node.get_child(5)
	new_cell.fluid = new_cell.node.get_child(6)
	new_cell.occluder.get_parent().remove_child(new_cell.occluder)
	new_cell.occluder.owner = null
	light_env.add_child(new_cell.occluder)
	new_cell.light.get_parent().remove_child(new_cell.light)
	new_cell.light.owner = null
	light_env.add_child(new_cell.light)
	new_cell.light.visible = false
	new_cell.particle_physics.visible = false
	new_cell.light.global_position = pos + Vector2i(256 / 2.0 - 1, 256 / 2.0 - 1)
	new_cell.occluder.occluder.polygon[0] = Vector2(0,0)
	new_cell.occluder.occluder.polygon[1] = Vector2(0,1)
	new_cell.occluder.occluder.polygon[2] = Vector2(1,1)
	new_cell.occluder.occluder.polygon[3] = Vector2(1,0)
	new_cell.occluder.global_position = pos + Vector2i(256 / 2.0 - 1, 256 / 2.0 - 1)
	new_cell.occluder.visible = false
	new_cell.fluid.material = new_cell.fluid.material.duplicate()
	cells.push_back(new_cell)
	add_child(new_cell.node)
	return new_cell

func set_cell(pos: Vector2i, cell: GameData.Cell):
	var c: Cell = get_cell_data(pos)
	var body: StaticBody2D = c.node.get_child(0)
	
	if cell.block:
		c.node.texture = cell.block.display.get_sprite(pos)
		c.node.material = cell.block.display.get_shader_material(pos, c.node.material)
		cell.block.display.update_material(pos, c.node.material)
		
		var rot = cell.block.display.get_rotation(pos)
		if rot == BlockDisplay.Rotation.UP:
			c.node.rotation_degrees = 0
		elif rot == BlockDisplay.Rotation.RIGHT:
			c.node.rotation_degrees = 90
		elif rot == BlockDisplay.Rotation.RIGHT:
			c.node.rotation_degrees = 180
		else:
			c.node.rotation_degrees = 270
		
		var collider_shape = cell.block.display.get_collider(pos)
		var collider: CollisionShape2D = body.get_child(0)
		var cshape: RectangleShape2D = collider.shape
		cshape.size = Vector2i(collider_shape.z, collider_shape.w)
		collider.position = Vector2i(collider_shape.x, collider_shape.y)
		body.process_mode = Node.PROCESS_MODE_ALWAYS if collider_shape != Vector4i.ZERO else Node.PROCESS_MODE_DISABLED
		c.particle_physics.visible = collider_shape != Vector4i.ZERO
		c.occluder.visible = cell.block.display.get_occlusion(pos)
		var light = cell.block.display.get_emission(pos)
		c.light.visible = light > 0
		
		var life: float = cell.block_state.get_life()
		if life > 0.8:
			c.break_sprite.texture = null
		elif life > 0.6:
			var at = AtlasTexture.new()
			at.atlas = BREAK_TEXTURE
			at.region = Rect2i(0,0,16,16)
			c.break_sprite.texture = at
		elif life > 0.4:
			var at = AtlasTexture.new()
			at.atlas = BREAK_TEXTURE
			at.region = Rect2i(16,0,16,16)
			c.break_sprite.texture = at
		elif life > 0.2:
			var at = AtlasTexture.new()
			at.atlas = BREAK_TEXTURE
			at.region = Rect2i(32,0,16,16)
			c.break_sprite.texture = at
		else:
			var at = AtlasTexture.new()
			at.atlas = BREAK_TEXTURE
			at.region = Rect2i(48,0,16,16)
			c.break_sprite.texture = at
			
	else:
		c.node.texture = air
		body.process_mode = Node.PROCESS_MODE_DISABLED
		c.occluder.visible = false
		c.break_sprite.texture = null
		c.light.visible = false
		c.particle_physics.visible = false

	if cell.backblock:
		c.backblock.texture = cell.backblock.display.get_sprite(pos)
	else:
		c.backblock.texture = null
	
	if cell.fluid:
		c.fluid.texture = cell.fluid.atlas
		var shader: ShaderMaterial = c.fluid.material
		shader.set_shader_parameter("quantity", cell.fluid_quantity)
		var down = Utils.get_direction_from_pos(Vector2i(cell.x, cell.y))
		c.fluid.rotation = - c.node.rotation + Vector2.UP.angle_to(down)
	else:
		c.fluid.texture = null

func get_cell(pos: Vector2i) -> Sprite2D:
	return get_cell_data(pos).node

func _ready() -> void:
	var image = Image.create_empty(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	air = ImageTexture.create_from_image(image)
