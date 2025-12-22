extends CharacterBody2D


const SPEED = 100.0
@onready var player: Sprite2D = $Player


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_x := Input.get_axis("ui_left", "ui_right")
	var input_y := Input.get_axis("ui_up", "ui_down")
	var dir := Vector2(input_x, input_y)
	
	if dir:
		velocity = dir * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	if input_x > 0:
		player.flip_h = false
	else:
		player.flip_h = true

	move_and_slide()
