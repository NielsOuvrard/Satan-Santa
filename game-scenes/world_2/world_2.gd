extends Node2D

var doors = []

func _ready() -> void:
	doors = [
		$Door,
		$Door2,
		$Door3,
		$Door4
	]
	SignalHandler.key_collected.connect(_new_key_collected)


func _new_key_collected(id: int):
	print("Signal received in world_2! Key ID: %d" % id)
	doors[id].unlock()
	print("Door %d unlocked!" % id)
