extends Control


func _ready() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game-scenes/world_3/world_3.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game-scenes/main_menu/main_menu.tscn")
