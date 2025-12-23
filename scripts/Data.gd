extends Node


var keyes_unlocked = []
var unlocked_computers = []

func _ready() -> void:
	SignalHandler.key_collected.connect(_on_key_collected)
	SignalHandler.computer_unlocked.connect(_on_computer_unlocked)

func _on_key_collected(key_id: int) -> void:
	if key_id not in keyes_unlocked:
		keyes_unlocked.append(key_id)
		print("Key %d saved to Data. Unlocked keys: %s" % [key_id, keyes_unlocked])

func _on_computer_unlocked(computer_id: int) -> void:
	if computer_id not in unlocked_computers:
		unlocked_computers.append(computer_id)
		print("Computer %d saved to Data. Unlocked computers: %s" % [computer_id, unlocked_computers])
