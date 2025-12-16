extends Node

func _create_game():
	GameData.map.generate_map()

func _on_play_button_pressed() -> void:
	var error = Network.host_game()
	if not error:
		_create_game()
		get_tree().change_scene_to_file("res://Scenes/Scenes/game.tscn")


func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/main_menu.tscn")
