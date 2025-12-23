extends CanvasLayer

@onready var input_player: Label = $Control/InputPlayer
@onready var word_displayed: Label = $Control/Displayed

const BLINK_INTERVAL: float = 0.5

var active: bool = false
var current_text: String = ""

var words_pool: Array[String] = ["html", "css", "NULL", "pointer", "char", "int", "bool", "void", "main", "function"]
var words_pool2: Array[String] = ["memory leak", "core dump", "stackoverflow", "buffer overflow", "race condition", "invalid free pointer", "malloc(sizeof)"]
var words_pool3: Array[String] = ["divide by zero", "out of bounds", "invalid pointer", "invalid operation", "invalid state", "invalid argument", "segmentation fault"]
var words_pool4: Array[String] = ["martin orhesser", "ruben habib", "agnes saez", "enzo scaduto", "marion huc", "antoine", "theo gaillardon"]

var target_words: Array[String] = []
var current_word_index: int = 0
var max_words: int = 2

var cursor_timer: float = 0.0
var cursor_visible: bool = true

var frame_id: int = 0

func _ready() -> void:
	var all_words = words_pool + words_pool2 + words_pool3 + words_pool4
	all_words.shuffle()
	target_words = all_words.slice(0, max_words)
	current_word_index = 0
	
	update_target_display()
	update_text_display()

func _input(event: InputEvent) -> void:
	if not active:
		return
	
	if current_word_index >= target_words.size():
		return

	print("Frame ID in ComputerScreen: %d" % frame_id)
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			current_text = ""
		elif event.keycode == KEY_BACKSPACE:
			if current_text.length() > 0:
				current_text = current_text.substr(0, current_text.length() - 1)
		else:
			if event.unicode != 0:
				current_text += char(event.unicode)
		
		if event.keycode == KEY_ESCAPE:
			SignalHandler.computer_screen_closed.emit(frame_id, false)
		
		update_text_display()
		check_word_match()

func _process(delta: float) -> void:
	cursor_timer += delta
	if cursor_timer >= BLINK_INTERVAL:
		cursor_timer = 0.0
		cursor_visible = !cursor_visible
		update_text_display()

func update_text_display() -> void:
	if cursor_visible:
		input_player.text = current_text + "_"
	else:
		input_player.text = current_text + "  "

func update_target_display() -> void:
	if current_word_index < target_words.size():
		word_displayed.text = target_words[current_word_index]
	else:
		word_displayed.text = "UNLOCKED"
		input_player.text = ""
		await get_tree().create_timer(1.0).timeout
		SignalHandler.computer_screen_closed.emit(frame_id, true)

func check_word_match() -> void:
	if current_word_index < target_words.size():
		if current_text.strip_edges().to_upper() == target_words[current_word_index].to_upper():
			current_word_index += 1
			current_text = ""
			update_text_display()
			update_target_display()
