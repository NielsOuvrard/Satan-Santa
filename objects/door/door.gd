extends Area2D

var opened := false

@export var locked := true
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label


func interact_door(opening: bool) -> void:
	if locked:
		return
	if opening:
		animated_sprite_2d.play("opening")
	else:
		animated_sprite_2d.play("closing")
	opened = opening


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		print("hello dorr player")
		# label.visible = true
		interact_door(true)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		# label.visible = false
		interact_door(false)


func _on_animated_sprite_2d_animation_finished() -> void:
	if opened:
		animated_sprite_2d.play("opened")
	else:
		animated_sprite_2d.play("closed")
