class_name SculptMinigame
extends Node

var blocks: Array[Sprite2D] = []

var _schema: Array[int] = [0,1,4,5,6,11,12,17,18,23,24,29]

var deleted: Array[int] = []
var selected: int = 0

var shader: Shader = load("res://Resources/Shaders/select.gdshader")

var failed: bool = false
var wait_before_start: float = 0.5

signal finished

func select(value: int):
	var old_block = blocks[selected]
	var old_material: ShaderMaterial = old_block.material
	old_material.set_shader_parameter("active", false)
	var block = blocks[value]
	var material: ShaderMaterial = block.material
	material.set_shader_parameter("active", true)
	selected = value

func start(schema: Array[int]):
	_schema = schema
	failed = false
	deleted.clear()
	wait_before_start = 0.5
	for block in blocks:
		block.material.set_shader_parameter("modulate", Color.from_rgba8(0,0,0,0))
		block.material.set_shader_parameter("hide", false)
	for id in _schema:
		blocks[id].material.set_shader_parameter("modulate", Color.from_rgba8(255,0,0,255))
	select(0)

func controls():
	if Input.is_action_just_pressed("ui_down"):
		var s = selected + 6
		if s > 35:
			s -= 6 * 6
		select(s)
	
	if Input.is_action_just_pressed("ui_up"):
		var s = selected - 6
		if s < 0:
			s += 6 * 6
		select(s)
		
	if Input.is_action_just_pressed("ui_left"):
		var s = selected - 1
		if s < 0 or s % 6 == 5:
			s += 6
		select(s)
		
	if Input.is_action_just_pressed("ui_right"):
		var s = selected + 1
		if s > 35 or s % 6 == 0:
			s -= 6
		select(s)
		
	if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_accept_mouse"):
		deleted.append(selected)
		blocks[selected].material.set_shader_parameter("hide", true)
		deleted.sort()
		if not _schema.has(selected):
			await get_tree().create_timer(1).timeout
			failed = true
			finished.emit()
		if deleted == _schema:
			await get_tree().create_timer(1).timeout
			finished.emit()

func _ready() -> void:
	var blocks_container: Node2D = get_node("Background/Blocks")
	for child in blocks_container.get_children():
		blocks.append(child)
		child.material = ShaderMaterial.new()
		child.material.shader = shader
	start(_schema)
	
func _process(delta: float) -> void:
	if wait_before_start > 0:
		wait_before_start -= delta
	if wait_before_start <= 0:
		controls()
	
	
