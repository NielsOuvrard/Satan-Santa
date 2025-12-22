extends CanvasLayer

## HUD displaying player inventory and torch energy

@onready var torch_display: HBoxContainer = $MarginContainer/HBoxContainer/LeftPanel/TorchDisplay
@onready var torch_progress: ProgressBar = $MarginContainer/HBoxContainer/LeftPanel/TorchDisplay/TorchProgress

var keys_collected: int = 0
var max_torch_energy: float = 100.0
var current_torch_energy: float = 100.0


func _ready() -> void:
	update_torch_display()
	
	# Connect to signals
	SignalHandler.torch_visibility_changed.connect(_on_torch_obtained)
	SignalHandler.torch_energy_changed.connect(_on_torch_energy_changed)
	# SignalHandler.key_collected.connect(_on_key_collected)


func _on_torch_obtained(visible: bool) -> void:
	torch_display.visible = visible


func _on_key_collected() -> void:
	keys_collected += 1


func _on_torch_energy_changed(energy: float, max_energy: float) -> void:
	current_torch_energy = energy
	max_torch_energy = max_energy
	update_torch_display()


func update_torch_display() -> void:
	torch_progress.value = (current_torch_energy / max_torch_energy) * 100.0


func set_torch_energy(energy: float, max_energy: float = 100.0) -> void:
	current_torch_energy = energy
	max_torch_energy = max_energy
	update_torch_display()
