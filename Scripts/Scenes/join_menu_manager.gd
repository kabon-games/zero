extends Node

var address: LineEdit = null

func _ready() -> void:
	address = get_node("VBoxContainer/address")
	Network.player_connected.connect(_on_joined)

func _on_joined():
	GameData.map.clear()
	GameData.receive_data.rpc_id(1, Network.me)
	get_tree().change_scene_to_file("res://Scenes/Scenes/game.tscn")

func _on_join_button_pressed() -> void:
	if Network.join_game(address.text):
		print(":<")


func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/main_menu.tscn")
