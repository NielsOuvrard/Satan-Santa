extends Control

@onready var credits_label: Label = $CreditsContainer/CreditsLabel

const SCROLL_SPEED = 30.0

func _process(delta: float) -> void:
	if credits_label:
		credits_label.position.y -= SCROLL_SPEED * delta
		if credits_label.position.y + credits_label.size.y < 0:
			credits_label.position.y = get_viewport_rect().size.y

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game-scenes/world_1/world_1.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
