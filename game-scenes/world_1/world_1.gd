extends Node2D

@onready var door: Area2D = $Door

@onready var key: Area2D = $Key

func _ready() -> void:
	SignalHandler.door_interacted.connect(_on_door_interacted)


func _on_door_interacted() -> void:
	get_tree().change_scene_to_file("res://game-scenes/world_2/world_2.tscn")
