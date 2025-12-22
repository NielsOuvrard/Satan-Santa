extends CharacterBody2D

const SPEED = 50.0

@export var player_path: NodePath
var player: Node2D = null

func _ready() -> void:
	if player_path:
		player = get_node(player_path)
	else:
		player = get_parent().get_node_or_null("Player")

func _physics_process(_delta: float) -> void:
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		move_and_slide()
	else:
		player = get_parent().get_node_or_null("Player")
