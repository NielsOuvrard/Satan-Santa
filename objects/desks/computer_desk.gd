extends StaticBody2D

var player_in_area = false
var fbkeys_sprite = null
var computer_screen_instance = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set process mode to always so we can unpause the game
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Get the FBkeys sprite
	fbkeys_sprite = $FBkeys
	fbkeys_sprite.visible = false
	
	# Connect to SignalHandler signals
	SignalHandler.launch_computer_screen.connect(_on_launch_computer_screen)
	SignalHandler.computer_screen_closed.connect(_on_computer_screen_closed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interaction"):
		print("Computer Desk used")
		# Pause the game
		get_tree().paused = true
		# Request computer screen launch via signal
		SignalHandler.request_computer_screen()

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
