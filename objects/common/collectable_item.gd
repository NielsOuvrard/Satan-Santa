extends Area2D
class_name CollectableItem

## Base class for all collectable items in the game.
## Provides floating animation and collection logic.

@export var float_amplitude: float = 5.0
@export var float_speed: float = 2.0
@export var sprite_offset_y: float = -24.0

@onready var item_sprite: Sprite2D = $ItemSprite

var initial_position: Vector2
var time_passed: float = 0.0


func _ready() -> void:
	add_to_group("collectables")
	initial_position = item_sprite.position
	_on_ready()


func _on_ready() -> void:
	# Override this in child classes for custom initialization
	pass


func _process(delta: float) -> void:
	time_passed += delta
	item_sprite.position.y = initial_position.y + sin(time_passed * float_speed) * float_amplitude
	_on_process(delta)


func _on_process(_delta: float) -> void:
	# Override this in child classes for custom per-frame logic
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_on_collected(body)
	else:
		print("A body of type %s entered the %s." % [body.get_class(), name])


func _on_collected(_player: Node2D) -> void:
	# Override this in child classes to define collection behavior
	# For example: give item to player, emit signal, etc.
	print("Item collected: %s" % name)
	queue_free()
