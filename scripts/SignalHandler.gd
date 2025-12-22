extends Node

signal torch_visibility_changed(visible: bool)
signal key_collected(id: int)
signal torch_energy_changed(energy: float, max_energy: float)


func set_torch_visibility(visible: bool) -> void:
	torch_visibility_changed.emit(visible)


func update_torch_energy(energy: float, max_energy: float) -> void:
	torch_energy_changed.emit(energy, max_energy)
