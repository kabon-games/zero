class_name NailMinigame
extends Node2D

var speed: float = 50
signal finished

var hammer: Sprite2D = null
var nail: Sprite2D = null

var nail_pos: float = 0
var hammer_direction: int = -1
var wait_before_start: float = 0.5

var is_pushing: bool = false

func start():
	wait_before_start = 0.5
	nail_pos = randf_range(10, 140)
	hammer.position.y = 8
	nail.position.y = 68
	nail.position.x = nail_pos

func push_animation(dt: float):
	var success: bool = hammer.position.x > nail_pos - 16 and hammer.position.x < nail_pos + 3
	is_pushing = true
	
	while hammer.position.y < 14:
		hammer.position.y += dt * 100
		await get_tree().process_frame
	while hammer.position.y < 43:
		hammer.position.y += dt * 100
		if success:
			nail.position.y += dt * 100
		await get_tree().process_frame
	if not success:
		while hammer.position.y > 8:
			hammer.position.y -= dt * 100
			await get_tree().process_frame
	if success:
		await get_tree().create_timer(1).timeout
		finished.emit()
	is_pushing = false

func controls(dt: float):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_accept_mouse"):
		await push_animation(dt)

func _ready() -> void:
	hammer = get_node("Background/Hammer")
	nail = get_node("Background/Nail")
	start()

func _process(delta: float) -> void:
	if wait_before_start > 0:
		wait_before_start -= delta
	if not is_pushing:
		if wait_before_start <= 0:
			controls(delta)
		hammer.position.x += hammer_direction * delta * speed
		if hammer.position.x < 0:
			hammer_direction = 1
		elif hammer.position.x > 150:
			hammer_direction = -1
	
