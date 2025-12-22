extends CollectableItem


func _on_collected(_player: Node2D) -> void:
	# Give the torch to the player
	SignalHandler.set_torch_visibility(true)
	queue_free()
