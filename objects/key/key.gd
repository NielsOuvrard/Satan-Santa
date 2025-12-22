extends CollectableItem

@export var frame := 0

func _on_ready() -> void:
	item_sprite.frame = frame

func _on_collected(_player: Node2D) -> void:
	# Add logic when key is collected (e.g., unlock doors, add to inventory)
	SignalHandler.key_collected.emit(frame)
	print("Key {%d} collected!" % frame)
	queue_free()
