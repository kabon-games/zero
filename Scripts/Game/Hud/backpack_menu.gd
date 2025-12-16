class_name BackpackMenu
extends Control

const cell_shader: Shader = preload("res://Resources/Shaders/select.gdshader")

var empty: Texture2D = null

var backpack: BackpackItemState = null
var inventory: Inventory = null
var item_cells: Array[TextureRect] = []
var selected: int = 0
var moving: int = -1

func select(value: int):
	if selected < item_cells.size():
		var cell = item_cells[selected]
		var mat: ShaderMaterial = cell.material
		mat.set_shader_parameter("active", false)
		
	selected = value
	
	if selected < item_cells.size():
		var cell = item_cells[selected]
		var mat = cell.material
		mat.set_shader_parameter("active", true)
		GameData.game_manager.hud.toolbar.override_select(-1)
	else:
		GameData.game_manager.hud.toolbar.override_select(selected - item_cells.size())

func update_slot(idx: int):
	if idx < item_cells.size():
		var slot = backpack.slots[idx]
		item_cells[idx].texture = slot.item.sprite if slot and slot.item else empty

func display(state: BackpackItemState, inv: Inventory):
	self.visible = true
	GameData.game_manager.hud.menu_toggled.emit(true)
	selected = 0
	backpack = state
	inventory = inv
	var i: int = 0
	for slot in state.slots:
		item_cells[i].texture = slot.item.sprite if slot and slot.item else empty
		i += 1
	select(0)

func move():
	if moving == -1:
		if selected < item_cells.size():
			var cell = item_cells[selected]
			var mat = cell.material
			mat.set_shader_parameter("modulate", Color(0,1,0,0.5))
		else:
			GameData.game_manager.hud.toolbar.modulate(selected - item_cells.size(), Color(0,1,0,0.5))
		moving = selected
	else:
		var stack: ItemStack = null
		if moving < item_cells.size():
			var cell = item_cells[moving]
			var mat = cell.material
			mat.set_shader_parameter("modulate", Color(0,0,0,0))
			stack = backpack.slots[moving]
			backpack.slots[moving] = null
			update_slot(moving)
		else:
			var toolbar_slot = moving - item_cells.size()
			GameData.game_manager.hud.toolbar.modulate(toolbar_slot, Color(0,0,0,0))
			stack = inventory.slots[toolbar_slot]
			inventory.update_slot(toolbar_slot, null)
		if selected < item_cells.size():
			backpack.slots[selected] = stack
			update_slot(selected)
		else:
			var toolbar_slot = selected - item_cells.size()
			inventory.update_slot(toolbar_slot, stack)
		
		moving = -1

func controls():
	if Input.is_action_just_pressed("ui_right"):
		select(selected + 1)
	if Input.is_action_just_pressed("ui_left"):
		select(selected - 1)
	if Input.is_action_just_pressed("ui_accept"):
		move()
	if Input.is_action_just_pressed("use_map"):
		self.visible = false
		GameData.game_manager.hud.menu_toggled.emit(false)
		GameData.game_manager.hud.toolbar.unoverride_select()

func _ready() -> void:
	empty = ImageTexture.create_from_image(Image.create_empty(16,16, false, Image.FORMAT_RGBA8))
	var items_container = get_node("Background/AspectRatioContainer/ItemsContainer")
	for child in items_container.get_children():
		item_cells.append(child.get_child(0))
		child.get_child(0).texture = null
		var mat: ShaderMaterial = ShaderMaterial.new()
		mat.shader = cell_shader
		child.get_child(0).material = mat

func _process(_delta: float) -> void:
	if visible:
		controls()
