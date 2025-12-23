extends CollectableItem


func _on_collected(_player: Node2D) -> void:
	# Give the torch to the player
	SignalHandler.torch_visibility_changed.emit(true)
	queue_free()
