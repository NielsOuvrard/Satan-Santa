extends CharacterBody2D

const SPEED = 100.0

var has_torch: bool = false
var torch_on: bool = false
var torch_energy: float = 100.0
var max_torch_energy: float = 100.0
var torch_drain_rate: float = 10.0 # Energy per second when torch is on

@onready var player: Sprite2D = $Player
@onready var torch_handled: Sprite2D = $TorchHandled
@onready var torch: PointLight2D = $TorchHandled/Torch

var flashlight_sound: AudioStreamPlayer
var footstep_player: AudioStreamPlayer
var footstep_timer: float = 0.0

var can_move: bool = true

func _ready() -> void:
	add_to_group("player")
	SignalHandler.torch_visibility_changed.connect(_on_torch_visibility_changed)
	SignalHandler.player_caught.connect(_on_player_caught)
	SignalHandler.screamer_finished.connect(_on_screamer_finished)
	SignalHandler.player_locked.connect(_on_player_locked)
	SignalHandler.player_unlocked.connect(_on_player_unlocked)
	
	flashlight_sound = AudioStreamPlayer.new()
	add_child(flashlight_sound)
	
	footstep_player = AudioStreamPlayer.new()
	footstep_player.stream = load("res://sounds/footstep.wav")
	footstep_player.volume_db = -21.0 # Adjust volume as needed
	add_child(footstep_player)


func _on_torch_visibility_changed(should_be_visible: bool) -> void:
	has_torch = should_be_visible
	torch_handled.visible = should_be_visible


func _on_player_caught() -> void:
	can_move = false
	velocity = Vector2.ZERO


func _on_screamer_finished() -> void:
	can_move = true


func _on_player_locked() -> void:
	can_move = false
	velocity = Vector2.ZERO


func _on_player_unlocked() -> void:
	can_move = true


func _physics_process(_delta: float) -> void:
	# Handle torch toggle
	if has_torch and Input.is_action_just_pressed("toggle_torch"):
		torch_on = !torch_on
		if torch_on:
			flashlight_sound.stream = load("res://sounds/flashlight-on.wav")
		else:
			flashlight_sound.stream = load("res://sounds/flashlight-off.wav")
		flashlight_sound.play()
	
	# Drain torch energy when on
	if has_torch and torch_on and torch_energy > 0:
		torch_energy = max(0, torch_energy - torch_drain_rate * _delta)
		SignalHandler.torch_energy_changed.emit(torch_energy, max_torch_energy)
		if torch_energy <= 0:
			torch_on = false
			flashlight_sound.stream = load("res://sounds/flashlight-off.wav")
			flashlight_sound.play()
		torch.visible = true
	else:
		torch.visible = false
		torch_energy = min(max_torch_energy, torch_energy + (torch_drain_rate / 4) * _delta) # Recharge when off
		SignalHandler.torch_energy_changed.emit(torch_energy, max_torch_energy)
	
	# Movement input - supports both keyboard and gamepad
	var input_x := 0.0
	var input_y := 0.0
	
	if can_move:
		# Keyboard/D-pad input
		if Input.is_action_pressed('ui_right'):
			input_x += 1
		if Input.is_action_pressed('ui_left'):
			input_x -= 1
		if Input.is_action_pressed('ui_down'):
			input_y += 1
		if Input.is_action_pressed('ui_up'):
			input_y -= 1
		
		# Gamepad analog stick for movement
		if Input.is_action_pressed('move_right'):
			input_x += Input.get_action_strength('move_right')
		if Input.is_action_pressed('move_left'):
			input_x -= Input.get_action_strength('move_left')
		if Input.is_action_pressed('move_down'):
			input_y += Input.get_action_strength('move_down')
		if Input.is_action_pressed('move_up'):
			input_y -= Input.get_action_strength('move_up')
	
	var dir := Vector2(input_x, input_y)
	if dir != Vector2.ZERO:
		dir = dir.normalized()
		velocity = dir * SPEED
		
		footstep_timer -= _delta
		if footstep_timer <= 0:
			footstep_player.play()
			footstep_timer = 0.5
		
		if input_x > 0:
			player.flip_h = false
		elif input_x < 0:
			player.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		footstep_timer = 0.0 # Reset timer when stopped so next step is immediate

	# Aiming - check for gamepad right stick input first
	var aim_direction := Vector2.ZERO
	
	# Gamepad right stick aiming
	if Input.is_action_pressed('look_right'):
		aim_direction.x += Input.get_action_strength('look_right')
	if Input.is_action_pressed('look_left'):
		aim_direction.x -= Input.get_action_strength('look_left')
	if Input.is_action_pressed('look_down'):
		aim_direction.y += Input.get_action_strength('look_down')
	if Input.is_action_pressed('look_up'):
		aim_direction.y -= Input.get_action_strength('look_up')
	
	# If gamepad stick is being used, use that direction
	if aim_direction.length() > 0.1: # Deadzone
		aim_direction = aim_direction.normalized()
		var angle := aim_direction.angle()
		if torch_handled.flip_h:
			torch_handled.rotation = PI - angle
		else:
			torch_handled.rotation = angle
	else:
		# Otherwise use mouse position
		var mouse_pos: Vector2 = get_global_mouse_position()
		var to_mouse: Vector2 = mouse_pos - torch_handled.global_position
		if to_mouse.length() > 0.001:
			var angle := to_mouse.angle()
			if torch_handled.flip_h:
				torch_handled.rotation = PI - angle
			else:
				torch_handled.rotation = angle

	move_and_slide()
