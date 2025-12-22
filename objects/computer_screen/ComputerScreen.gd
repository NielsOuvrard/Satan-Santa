extends Control

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label2: Label = $Label2

var current_text: String = ""

var words_pool: Array[String] = ["html", "css", "NULL", "pointer", "char", "int", "bool", "void", "main", "function"]
var words_pool2: Array[String] = ["memory leak", "core dump", "stackoverflow", "buffer overflow", "race condition", "invalid free pointer", "malloc(sizeof)"]
var words_pool3: Array[String] = ["divide by zero", "out of bounds", "invalid pointer", "invalid operation", "invalid state", "invalid argument", "segmentation fault"]
var words_pool4: Array[String] = ["martin orhesser", "ruben habib", "agnes saez", "enzo scaduto", "marion huc", "antoine", "theo gaillardon"]

var target_words: Array[String] = []
var current_word_index: int = 0
var max_words: int = 7

signal minigame_finished

func _ready() -> void:
	var all_words = words_pool + words_pool2 + words_pool3 + words_pool4
	all_words.shuffle()
	target_words = all_words.slice(0, max_words)
	current_word_index = 0
	
	update_target_display()
	update_text_display()

func _input(event: InputEvent) -> void:
	if current_word_index >= target_words.size():
		return

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			current_text = ""
		elif event.keycode == KEY_BACKSPACE:
			if current_text.length() > 0:
				current_text = current_text.substr(0, current_text.length() - 1)
		else:
			if event.unicode != 0:
				current_text += char(event.unicode)
		
		update_text_display()
		check_word_match()

var cursor_timer: float = 0.0
var cursor_visible: bool = true
const BLINK_INTERVAL: float = 0.5

func _process(delta: float) -> void:
	cursor_timer += delta
	if cursor_timer >= BLINK_INTERVAL:
		cursor_timer = 0.0
		cursor_visible = !cursor_visible
		update_text_display()

func update_text_display() -> void:
	if cursor_visible:
		label.text = current_text + "_"
	else:
		label.text = current_text + "  "

func update_target_display() -> void:
	if current_word_index < target_words.size():
		label2.text = target_words[current_word_index]
	else:
		label2.text = "UNLOCKED"
		label.text = ""
		emit_signal("minigame_finished")
		await get_tree().create_timer(1.5).timeout
		queue_free()

func check_word_match() -> void:
	if current_word_index < target_words.size():
		if current_text.strip_edges().to_upper() == target_words[current_word_index].to_upper():
			current_word_index += 1
			current_text = ""
			update_text_display()
			update_target_display()
