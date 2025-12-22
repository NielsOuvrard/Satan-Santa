extends Node2D

@export var float_amplitude: float = 5.0
@export var float_speed: float = 2.0

@onready var torch_item: Sprite2D = $TorchItem

var initial_position: Vector2
var time_passed: float = 0.0


func _ready() -> void:
	initial_position = torch_item.position


func _process(delta: float) -> void:
	time_passed += delta
	torch_item.position.y = initial_position.y + sin(time_passed * float_speed) * float_amplitude


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalHandler.set_torch_visibility(true)
		queue_free()
	else:
		print("An body of type %s entered the torch body." % body.get_class())
