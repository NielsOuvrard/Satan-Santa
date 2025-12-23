extends CharacterBody2D

const SPEED = 15.0

@export var player_path: NodePath
var player: Node2D = null

var footstep_sound = preload("res://sounds/ruben_footstep.wav")
var footstep_player: AudioStreamPlayer2D
var footstep_timer: float = 0.0
const FOOTSTEP_INTERVAL: float = 0.7

var initial_position: Vector2

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

func _physics_process(_delta: float) -> void:
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("player"):
				SignalHandler.player_caught.emit()
		
		if velocity.length() > 1.0:
			footstep_timer -= _delta
			if footstep_timer <= 0.0:
				footstep_player.play()
				footstep_timer = FOOTSTEP_INTERVAL
		else:
			footstep_timer = 0.0
	else:
		player = get_parent().get_node_or_null("Player")


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
