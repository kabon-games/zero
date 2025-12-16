class_name HudManager
extends CanvasLayer

var toolbar: Toolbar = null
var craft_menu: CraftMenu = null
var craft_table_menu: CraftTableMenu = null
var back_pack_menu: BackpackMenu = null

var minigames: Node2D = null

var nail_minigame: NailMinigame = null
var sculpt_minigame: SculptMinigame = null
var thread_minigame: ThreadMinigame = null

signal menu_toggled(is_open: bool)

func _ready() -> void:
	toolbar = get_node("ItemBarTexture")
	craft_menu = get_node("CraftMenu")
	craft_table_menu = get_node("CraftTableMenu")
	back_pack_menu = get_node("BackpackMenu")
	minigames = get_node("Minigames")
	
	nail_minigame = get_node("Minigames/NailMinigame")
	sculpt_minigame = get_node("Minigames/SculptMinigame")
	thread_minigame = get_node("Minigames/ThreadMinigame")

func _controls():
	if Input.is_action_just_pressed("craft_menu"):
		craft_menu.visible = not craft_menu.visible
		menu_toggled.emit(craft_menu.visible)
		
func _process(_delta: float) -> void:
	_controls()
	minigames.global_position = minigames.get_viewport_rect().end / 2
