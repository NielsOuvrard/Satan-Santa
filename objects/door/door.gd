extends Area2D

var opened := false

@export var locked := true
@export var frame_id := 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hublo: Sprite2D = $Hublo
@onready var reader: Sprite2D = $Reader
@onready var label: Label = $Label

func _ready() -> void:
	hublo.frame = frame_id + 1
	
	if not locked:
		reader.frame

func interact_door(opening: bool) -> void:
	if locked:
		return
	#if opening:
		#animated_sprite_2d.play("opening")
	#else:
		#animated_sprite_2d.play("closing")
	#opened = opening

func unlock():
	locked = false
	reader.frame = 0

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		interact_door(true)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		# label.visible = false
		interact_door(false)


#func _on_animated_sprite_2d_animation_finished() -> void:
	#if opened:
		#animated_sprite_2d.play("opened")
	#else:
		#animated_sprite_2d.play("closed")
