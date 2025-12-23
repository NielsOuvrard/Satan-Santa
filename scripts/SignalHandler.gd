extends Node

signal torch_visibility_changed(visible: bool)
signal key_collected(id: int)
signal torch_energy_changed(energy: float, max_energy: float)
signal door_interacted()
signal player_caught()
signal screamer_finished()

func set_torch_visibility(visible: bool) -> void:
	torch_visibility_changed.emit(visible)


func update_torch_energy(energy: float, max_energy: float) -> void:
	torch_energy_changed.emit(energy, max_energy)


func catch_player() -> void:
	player_caught.emit()


func finish_screamer() -> void:
	screamer_finished.emit()
