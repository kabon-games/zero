extends Node



func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_host_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/host_menu.tscn")


func _on_join_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/join_menu.tscn")
