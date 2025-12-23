extends CanvasLayer

## HUD displaying player inventory and torch energy

@onready var torch_display: HBoxContainer = $MarginContainer/HBoxContainer/LeftPanel/TorchDisplay
@onready var torch_progress: ProgressBar = $MarginContainer/HBoxContainer/LeftPanel/TorchDisplay/TorchProgress
@onready var key_display: HBoxContainer = $MarginContainer/HBoxContainer/RightPanel/KeyDisplay

var max_torch_energy: float = 100.0
var current_torch_energy: float = 100.0


func _ready() -> void:
	update_torch_display()
	update_key_display()
	
	# Connect to signals
	SignalHandler.torch_visibility_changed.connect(_on_torch_obtained)
	SignalHandler.torch_energy_changed.connect(_on_torch_energy_changed)
	SignalHandler.player_caught.connect(_on_player_caught)
	SignalHandler.key_collected.connect(_on_key_collected)
	SignalHandler.computer_unlocked.connect(_on_computer_unlocked)
	
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
	# Change to game over scene
	get_tree().change_scene_to_file("res://game-scenes/game_over/game_over.tscn")


func _on_torch_obtained(visible: bool) -> void:
	torch_display.visible = visible


func _on_key_collected(key_id: int) -> void:
	update_key_display()


func _on_computer_unlocked(computer_id: int) -> void:
	update_key_display()


func update_key_display() -> void:
	# Clear existing key sprites
	for child in key_display.get_children():
		child.queue_free()
	
	# Get keys that are collected but not yet used
	var available_keys = []
	for key_id in Data.keyes_unlocked:
		if key_id not in Data.unlocked_computers:
			available_keys.append(key_id)
	
	# Show key display only if there are keys
	key_display.visible = available_keys.size() > 0
	
	# Create sprite for each available key
	var position_offset = 0
	for key_id in available_keys:
		var key_sprite = Sprite2D.new()
		key_sprite.texture = load("res://objects/key/keyes.png")
		key_sprite.vframes = 4
		key_sprite.frame = key_id
		key_sprite.rotation = PI / 2  # 90 degrees rotation
		key_sprite.scale = Vector2(15, 15)
		key_sprite.position = Vector2(position_offset, 0)
		position_offset -= key_sprite.texture.get_width() * key_sprite.scale.x + 10
		key_display.add_child(key_sprite)


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
