extends CharacterBody2D

const SPEED = 15.0

@export var player_path: NodePath
var player: Node2D = null

var footstep_sound = preload("res://sounds/ruben_footstep.wav")
var footstep_player: AudioStreamPlayer2D
var footstep_timer: float = 0.0
const FOOTSTEP_INTERVAL: float = 0.7

var initial_position: Vector2

enum State {
	PATROL,
	CHASE,
	RETURN
}

var current_state = State.PATROL

@export var patrol_speed = 30.0
@export var chase_speed = 50.0
@export var path_follow_node: PathFollow2D

@export var detection_range: float = 200.0:
	set(value):
		detection_range = value
		var shape_node = $DetectionArea/CollisionShape2D
		if shape_node and shape_node.shape is CircleShape2D:
			shape_node.shape.radius = value

func _ready() -> void:
	initial_position = position
	SignalHandler.screamer_finished.connect(_on_screamer_finished)
	
	if player_path:
		player = get_node(player_path)
	else:
		player = get_parent().get_node_or_null("Player")
	
	footstep_player = AudioStreamPlayer2D.new()
	footstep_player.stream = footstep_sound
	footstep_player.volume_db = -15.0
	footstep_player.max_distance = 500.0
	footstep_player.attenuation = 3.0
	add_child(footstep_player)

func process_patrol(delta: float) -> void:
	if path_follow_node:
		path_follow_node.progress += patrol_speed * delta
		global_position = path_follow_node.global_position
		_update_footsteps(delta, true)

func process_chase(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * chase_speed
		move_and_slide()
		_check_player_collision()
		_update_footsteps(delta, velocity.length() > 1.0)

func process_return(delta: float) -> void:
	if path_follow_node:
		var target_pos = path_follow_node.global_position
		var direction = (target_pos - global_position).normalized()
		
		if global_position.distance_to(target_pos) < 5.0:
			current_state = State.PATROL
		else:
			velocity = direction * patrol_speed
			move_and_slide()
			_update_footsteps(delta, velocity.length() > 1.0)

func _physics_process(delta: float) -> void:
	if not player:
		player = get_parent().get_node_or_null("Player")
		return

	match current_state:
		State.PATROL:
			process_patrol(delta)
		State.CHASE:
			process_chase(delta)
		State.RETURN:
			process_return(delta)

func _check_player_collision() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("player"):
			SignalHandler.catch_player()

func _update_footsteps(delta: float, is_moving: bool) -> void:
	if is_moving:
		footstep_timer -= delta
		if footstep_timer <= 0.0:
			footstep_player.play()
			footstep_timer = FOOTSTEP_INTERVAL
	else:
		footstep_timer = 0.0

# --- Signaux de Detection (A connecter depuis l'éditeur) ---
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		current_state = State.CHASE

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		current_state = State.RETURN


func _on_screamer_finished() -> void:
	visible = false
	set_physics_process(false)
	set_process(false)
	
	$CollisionGround.set_deferred("disabled", true)
	
	var timer = get_tree().create_timer(30.0)
	timer.timeout.connect(_respawn)


func _respawn() -> void:
	visible = true
	set_physics_process(true)
	set_process(true)
	$CollisionGround.set_deferred("disabled", false)
	
	position = initial_position
