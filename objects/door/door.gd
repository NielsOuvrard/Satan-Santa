extends Area2D

var opened := false

@export var locked := true
@export var frame_id := 0

@onready var hublo: Sprite2D = $Hublo
@onready var door: Sprite2D = $Door
@onready var reader: Sprite2D = $Reader

var door_sound: AudioStreamPlayer2D

func _ready() -> void:
	door_sound = AudioStreamPlayer2D.new()
	door_sound.stream = load("res://sounds/opening-door.wav")
	door_sound.volume_db = -10.0
	door_sound.max_distance = 500.0
	door_sound.attenuation = 2.0
	add_child(door_sound)

	hublo.frame = frame_id
	
	# Check if the corresponding computer has been unlocked
	if frame_id in Data.unlocked_computers:
		unlock()
	
	# Connect to computer unlock signal to unlock this door when computer is used
	SignalHandler.computer_unlocked.connect(_on_computer_unlocked)

func interact_door(opening: bool) -> void:
	if locked:
		return
	if opening and not opened:
		door_sound.play()
	opened = opening
	SignalHandler.door_interacted.emit()
	#if opening:
		#animated_sprite_2d.play("opening")
	#else:
		#animated_sprite_2d.play("closing")

func unlock() -> void:
	locked = false
	opened = true
	hublo.visible = false
	door.frame = 1 # opened
	reader.frame = 0 # opened
	door_sound.play()

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


#func _on_animated_sprite_2d_animation_finished() -> void:
	#if opened:
		#animated_sprite_2d.play("opened")
	#else:
		#animated_sprite_2d.play("closed")
