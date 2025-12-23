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
	SignalHandler.player_caught.connect(_on_player_caught)
	# SignalHandler.key_collected.connect(_on_key_collected)
	
	_setup_screamer()

var screamer_rect: TextureRect
var screamer_player: AudioStreamPlayer
var screamer_timer: Timer

func _setup_screamer() -> void:
	screamer_rect = TextureRect.new()
	screamer_rect.texture = load("res://objects/Screamer.png")
	screamer_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	screamer_rect.visible = false
	screamer_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	screamer_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(screamer_rect)
	
	screamer_player = AudioStreamPlayer.new()
	screamer_player.stream = load("res://sounds/screamer_v1.wav")
	screamer_player.volume_db = -10.0
	add_child(screamer_player)
	
	screamer_timer = Timer.new()
	screamer_timer.one_shot = true
	screamer_timer.wait_time = 4.0
	screamer_timer.timeout.connect(_on_screamer_timeout)
	add_child(screamer_timer)

func _process(delta: float) -> void:
	if screamer_rect.visible:
		# Shake effect
		var shake_amount = 50.0
		var offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		screamer_rect.position = offset
		
		# Zoom effect
		var zoom_speed = 50.0
		var zoom_scale = 1.5 + sin(Time.get_ticks_msec() * 0.02) * 0.1
		screamer_rect.scale = Vector2(zoom_scale, zoom_scale)
		# Center the zoom
		screamer_rect.pivot_offset = screamer_rect.size / 2

func _on_player_caught() -> void:
	if not screamer_rect.visible:
		screamer_rect.visible = true
		screamer_player.play()
		screamer_timer.start()

func _on_screamer_timeout() -> void:
	screamer_rect.visible = false
	screamer_player.stop()
	SignalHandler.screamer_finished.emit()


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
