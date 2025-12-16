class_name GameManager
extends Node

const PLAYER_PREFAB = preload("res://Scenes/Game/player.tscn")
const MAP_PREFAB = preload("res://Scenes/Game/map.tscn")

var players : Array[Player] = []
var camera: Camera2D = null
var map: Map = null
var hud: HudManager = null

var is_raining: bool = false

func get_me() -> Player:
	for player in players:
		if player.id == Network.me:
			return player
	return null

func add_player(id: int) -> Player:
	var player: Player = PLAYER_PREFAB.instantiate()
	player.id = id
	player.name = "Player_" + str(id)
	self.add_child(player)
	player.global_position.y = -15 * 16
	players.push_back(player)
	player.inventory.generate_default_inventory()
	return player

func launch_rain():
	is_raining = true
	map.toggle_rain(true)
	var duration = randf_range(10, 60)
	await get_tree().create_timer(duration).timeout
	map.toggle_rain(false)
	is_raining = false
	

func _ready() -> void:
	GameData.game_manager = self
	camera = get_node("Camera2D")
	hud = get_node("HUD")
	
	get_tree().root.get_viewport().canvas_cull_mask = get_tree().root.get_viewport().canvas_cull_mask - 16
	get_tree().root.get_viewport().canvas_cull_mask = get_tree().root.get_viewport().canvas_cull_mask - 32
	
	map = MAP_PREFAB.instantiate()
	self.add_child(map)
	
	var me = add_player(Network.me)
	me.select_block.connect(map.select_cell)
	GameData.map.updated_block.connect(map.update_cell_at)
	me.inventory.slot_updated.connect(hud.toolbar.update_slot)
	me.inventory.slot_selected.connect(hud.toolbar.select)
	hud.menu_toggled.connect(me.toggle_menu)
	hud.toolbar.update_all(me.inventory)
	
	for id in multiplayer.get_peers():
		add_player(id)
		
	Network.player_joined.connect(add_player)
	GameData.gamedata_updated.connect(_update_game)
	
func _update_game():
	map.update_all()
		
func _process(_delta: float) -> void:
	var me = get_me()
	if me:
		camera.global_position.x = me.global_position.x
		camera.global_position.y = me.global_position.y
		camera.global_rotation = me.global_rotation
		
	if not is_raining and randf() > 0.999:
		launch_rain()
	
	
