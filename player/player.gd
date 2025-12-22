extends CharacterBody2D

const SPEED = 100.0

@onready var player: Sprite2D = $Player
@onready var torch_handled: Sprite2D = $TorchHandled

var local_torch_position: Vector2


func _ready() -> void:
	add_to_group("player")
	local_torch_position = torch_handled.position
	SignalHandler.torch_visibility_changed.connect(_on_torch_visibility_changed)


func _on_torch_visibility_changed(visible: bool) -> void:
	torch_handled.visible = visible


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_x := Input.get_axis("ui_left", "ui_right")
	var input_y := Input.get_axis("ui_up", "ui_down")
	var dir := Vector2(input_x, input_y)
	
	if dir != Vector2.ZERO:
		velocity = dir * SPEED
		
		if input_x > 0:
			player.flip_h = false
			torch_handled.flip_h = false
			torch_handled.position.x = local_torch_position.x
		else:
			torch_handled.position.x = - local_torch_position.x
			torch_handled.flip_h = true
			player.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	

	move_and_slide()
