extends CollectableItem


func _on_collected(_player: Node2D) -> void:
	# Add logic when key is collected (e.g., unlock doors, add to inventory)
	print("Key collected!")
	# Example: SignalHandler.key_collected.emit()
	queue_free()
