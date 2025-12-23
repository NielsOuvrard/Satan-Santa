extends StaticBody2D

var opened := false

@export var locked := true
@export var frame_id := 0

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hublo: Sprite2D = $Hublo
@onready var door: Sprite2D = $Door
@onready var reader: Sprite2D = $Reader

func _ready() -> void:
	hublo.frame = frame_id
	if frame_id == 4: # exit
		hublo.frame = 0
	
	# Check if the corresponding computer has been unlocked
	if frame_id in Data.unlocked_computers:
		unlock()
	
	# Connect to computer unlock signal to unlock this door when computer is used
	SignalHandler.computer_unlocked.connect(_on_computer_unlocked)

func interact_door(opening: bool) -> void:
	if locked:
		return
	opened = opening
	SignalHandler.door_interacted.emit()

func unlock() -> void:
	locked = false
	opened = true
	hublo.visible = false
	door.frame = 1 # opened
	reader.frame = 0 # opened
	collision.disabled = true

func _on_computer_unlocked(computer_id: int) -> void:
	if computer_id == frame_id:
		unlock()
		print("Door ID %d unlocked by Computer ID %d!" % [frame_id, computer_id])
	else:
		print("Computer ID %d does not match Door ID %d. No action taken." % [computer_id, frame_id])

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact_door(true)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact_door(false)

func _on_exit_area_body_entered(body: Node2D) -> void:
	if frame_id == 4: # exit
		# change scene to victory_menu
		pass
