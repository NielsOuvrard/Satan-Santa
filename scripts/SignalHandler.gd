extends Node

signal torch_visibility_changed(visible: bool)


func set_torch_visibility(visible: bool) -> void:
	torch_visibility_changed.emit(visible)
