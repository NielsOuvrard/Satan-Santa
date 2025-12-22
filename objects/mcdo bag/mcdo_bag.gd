extends Node2D

@onready var bag: Sprite2D = $Bag

var time := 0.0

func _process(delta):
	bag.position.y += (cos(time * 5) * 10) * delta  # Sine movement (up and down)
	
	time += delta
