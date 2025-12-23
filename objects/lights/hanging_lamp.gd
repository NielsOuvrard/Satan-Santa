extends Node2D

@onready var light_cone: PointLight2D = $PointLight2D
@onready var light_halo: PointLight2D = $GroundHalo

@export var min_energy: float = 0.0
@export var max_energy: float = 2.0
@export var flicker_chance: float = 0.01 # Chance per frame to start flickering

var is_flickering: bool = false
var flicker_timer: float = 0.0

var audio_player: AudioStreamPlayer2D

func _ready() -> void:
	light_cone.energy = max_energy
	light_halo.energy = max_energy
	
	audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = load("res://sounds/background_light.wav")
	audio_player.max_distance = 350.0
	audio_player.attenuation = 3.0
	audio_player.volume_db = -5.0
	audio_player.finished.connect(func(): audio_player.play())
	add_child(audio_player)
	audio_player.play()

func _process(delta: float) -> void:
	if is_flickering:
		flicker_timer -= delta
		if flicker_timer <= 0:
			is_flickering = false
			light_cone.energy = max_energy
			light_halo.energy = max_energy
		else:
			# Random energy during flicker
			var new_energy = randf_range(min_energy, max_energy)
			# Sometimes go completely dark
			if randf() > 0.7:
				new_energy = 0.0
			
			light_cone.energy = new_energy
			light_halo.energy = new_energy
	else:
		# Random chance to start flickering
		if randf() < flicker_chance:
			start_flicker()

func start_flicker() -> void:
	is_flickering = true
	# Flicker for a random duration between 0.05 and 0.2 seconds
	flicker_timer = randf_range(0.05, 0.2)
	
	# Small chance to have a "blackout" (longer flicker where it stays mostly off)
	if randf() < 0.3:
		flicker_timer += randf_range(0.2, 0.5)
