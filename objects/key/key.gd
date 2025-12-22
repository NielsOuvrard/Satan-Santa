extends CollectableItem

@export var frame := 0

func _on_ready() -> void:
	item_sprite.frame = frame

func _on_collected(_player: Node2D) -> void:
	# Add logic when key is collected (e.g., unlock doors, add to inventory)
	print("Key collected!")
	SignalHandler.key_collected.emit(frame)
	queue_free()
