extends CollectableItem

@export var frame := 0

func _on_ready() -> void:
	item_sprite.frame = frame

func _on_collected(_player: Node2D) -> void:
	# Save key ID to Data and emit signal
	SignalHandler.key_collected.emit(frame)
	print("Key {%d} collected!" % frame)
	queue_free()
