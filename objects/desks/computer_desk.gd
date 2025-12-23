extends StaticBody2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var fb_keys: Sprite2D = $FBkeys
@onready var computer: Sprite2D = $Computer

var player_in_area = false
var fbkeys_sprite = null
var computer_screen_instance = null

@export var frame_id := 0
# Flicker settings (mirrors objects/lights/hanging_lamp.gd)
@export var min_energy: float = 0.0
@export var max_energy: float = 2.0
@export var flicker_chance: float = 0.01

var is_flickering: bool = false
var flicker_timer: float = 0.0

# Floating FBkeys (mirrors CollectableItem behavior)
@export var fb_float_amplitude: float = 5.0
@export var fb_float_speed: float = 2.0
var fb_time_passed: float = 0.0
var fb_initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	computer.frame = frame_id
	print("frame id of computer %d", frame_id)
	# Set process mode to always so we can unpause the game
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Initialize light energy
	point_light_2d.energy = max_energy
	
	# Get the FBkeys sprite
	fbkeys_sprite = $FBkeys
	fbkeys_sprite.visible = false
	# Record initial position for floating animation
	fb_initial_position = fb_keys.position
	
	# Connect to SignalHandler signals
	SignalHandler.launch_computer_screen.connect(_on_launch_computer_screen)
	SignalHandler.computer_screen_closed.connect(_on_computer_screen_closed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Handle light flickering (similar to hanging_lamp.gd)
	if is_flickering:
		flicker_timer -= delta
		if flicker_timer <= 0.0:
			is_flickering = false
			point_light_2d.energy = max_energy
		else:
			var new_energy = randf_range(min_energy, max_energy)
			if randf() > 0.7:
				new_energy = 0.0
			point_light_2d.energy = new_energy
	else:
		if randf() < flicker_chance:
			start_flicker()

	# Float the FBkeys sprite up and down (CollectableItem-like)
	fb_time_passed += delta
	fb_keys.position.y = fb_initial_position.y + sin(fb_time_passed * fb_float_speed) * fb_float_amplitude

	if player_in_area and Input.is_action_just_pressed("interaction"):
		print("Computer Desk used")
		# Pause the game
		get_tree().paused = true
		# Request computer screen launch via signal
		SignalHandler.request_computer_screen()

func start_flicker() -> void:
	is_flickering = true
	# Flicker for a random short duration; occasional longer blackout
	flicker_timer = randf_range(0.05, 0.2)
	if randf() < 0.3:
		flicker_timer += randf_range(0.2, 0.5)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = true
		fbkeys_sprite.visible = true
		print("FBkeys")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		fbkeys_sprite.visible = false

func _on_launch_computer_screen() -> void:
	# Launch the ComputerScreen scene as an HUD on top of everything
	var computer_screen = load("res://objects/computer_screen/ComputerScreen.tscn")
	computer_screen_instance = computer_screen.instantiate()
	#computer_screen_instance.z_index = 100
	computer_screen_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	computer_screen_instance.active = true
	get_tree().root.add_child(computer_screen_instance)
	# Connect to tree_exited to know when the screen closes itself

func _on_computer_screen_closed() -> void:
	# Unpause the game when computer screen is closed
	get_tree().paused = false
	computer_screen_instance.queue_free()
