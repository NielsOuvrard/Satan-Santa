extends Node2D

@onready var door: Area2D = $Door

@onready var key: Area2D = $Key

func _ready() -> void:
	SignalHandler.key_collected.connect(_open_the_door)
	SignalHandler.door_interacted.connect(_on_door_interacted)


func _open_the_door(id: int):
	door.unlock()

func _on_door_interacted() -> void:
	get_tree().change_scene_to_file("res://game-scenes/world_2/world_2.tscn")
