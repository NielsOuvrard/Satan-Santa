extends Node2D

@onready var light: PointLight2D = $PointLight2D

var timer: float = 0.0

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		flicker()

func flicker() -> void:
	timer = randf_range(0.05, 0.2)
	if randf() > 0.5:
		light.enabled = !light.enabled
	else:
		light.enabled = true
		light.energy = randf_range(0.5, 2.0)
