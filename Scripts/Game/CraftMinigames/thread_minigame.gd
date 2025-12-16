class_name ThreadMinigame
extends Node2D

const thread_sprites: Array[CompressedTexture2D] = [
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread1.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread2.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread3.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread4.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread5.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread6.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread7.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread8.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread9.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread10.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread11.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread12.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread13.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread14.png"),
	preload("res://Assets/Sprites/hud/CraftMinigames/ThreadMinigame/thread15.png"),
	
]

signal finished

var thread_sprite: Sprite2D = null
var progress: float = 0
var direction: Vector2i = Vector2i.RIGHT

func update_display():
	thread_sprite.texture = thread_sprites[progress]

func start():
	progress = 0
	update_display()

func controls():
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_pos -= get_viewport_rect().end / 2
	
	if direction == Vector2i.RIGHT and mouse_pos.x > 1:
		direction = Vector2i.DOWN
	
	if direction == Vector2i.DOWN and mouse_pos.y > 1:
		direction = Vector2i.LEFT
	
	if direction == Vector2i.LEFT and mouse_pos.x < -1:
		direction = Vector2i.UP
		
	if direction == Vector2i.UP and mouse_pos.y < -1:
		direction = Vector2i.RIGHT
		progress += 1
		if progress >= thread_sprites.size():
			await get_tree().create_timer(1).timeout
			finished.emit()
		else:
			update_display()
		

func _ready() -> void:
	thread_sprite = get_node("Background/Thread")
	start()

func _process(_delta: float) -> void:
	controls()
