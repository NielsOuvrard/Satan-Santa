extends Node

signal torch_visibility_changed(visible: bool)
signal key_collected(id: int)


func set_torch_visibility(visible: bool) -> void:
	torch_visibility_changed.emit(visible)
