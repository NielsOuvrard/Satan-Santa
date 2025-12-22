extends Node2D

@onready var door: Area2D = $Door

@onready var key: Area2D = $Key

func _ready() -> void:
	SignalHandler.key_collected.connect(_open_the_door)


func _open_the_door(id: int):
	door.locked = false
