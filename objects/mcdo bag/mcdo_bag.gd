extends CollectableItem


func _on_ready() -> void:
	# Customize floating parameters for McDo bag
	float_speed = 5.0
	float_amplitude = 10.0


func _on_collected(_player: Node2D) -> void:
	# Add logic here when the bag is collected (e.g., add to inventory, play sound)
	print("McDo bag collected!")
	queue_free()
