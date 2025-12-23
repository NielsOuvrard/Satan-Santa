extends Control


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game-scenes/world_1/world_1.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game-scenes/main_menu/main_menu.tscn")
