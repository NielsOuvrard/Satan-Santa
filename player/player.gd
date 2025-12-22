extends CharacterBody2D

const SPEED = 100.0

var has_torch: bool = false
var torch_on: bool = false
var torch_energy: float = 100.0
var max_torch_energy: float = 100.0
var torch_drain_rate: float = 10.0  # Energy per second when torch is on

@onready var player: Sprite2D = $Player
@onready var torch_handled: Sprite2D = $TorchHandled
@onready var torch: PointLight2D = $TorchHandled/Torch

func _ready() -> void:
	add_to_group("player")
	SignalHandler.torch_visibility_changed.connect(_on_torch_visibility_changed)


func _on_torch_visibility_changed(should_be_visible: bool) -> void:
	has_torch = should_be_visible
	torch_handled.visible = should_be_visible


func _physics_process(_delta: float) -> void:
	# Handle torch toggle
	if has_torch and Input.is_action_just_pressed("ui_accept"):  # Space key
		torch_on = !torch_on
	
	# Drain torch energy when on
	if has_torch and torch_on and torch_energy > 0:
		torch_energy = max(0, torch_energy - torch_drain_rate * _delta)
		SignalHandler.update_torch_energy(torch_energy, max_torch_energy)
		if torch_energy <= 0:
			torch_on = false
		torch.visible = true
	else:
		torch.visible = false
		torch_energy = min(max_torch_energy, torch_energy + (torch_drain_rate / 4) * _delta)  # Recharge when off
		SignalHandler.update_torch_energy(torch_energy, max_torch_energy)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_x := Input.get_axis("ui_left", "ui_right")
	var input_y := Input.get_axis("ui_up", "ui_down")
	var dir := Vector2(input_x, input_y)
	
	if dir != Vector2.ZERO:
		velocity = dir * SPEED
		
		if input_x > 0:
			player.flip_h = false
		else:
			player.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	# Rotate torch and point light to follow the mouse every frame.
	var mouse_pos: Vector2 = get_global_mouse_position()
	var to_mouse: Vector2 = mouse_pos - torch_handled.global_position
	if to_mouse.length() > 0.001:
		var angle := to_mouse.angle()
		# If the torch sprite is flipped horizontally, mirror the rotation so
		# the visual still points at the mouse.
		if torch_handled.flip_h:
			torch_handled.rotation = PI - angle
		else:
			torch_handled.rotation = angle
		# Keep the light's rotation matching the computed angle.

	move_and_slide()
