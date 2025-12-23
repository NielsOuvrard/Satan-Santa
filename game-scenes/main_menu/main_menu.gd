extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game-scenes/world_1/world_1.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
