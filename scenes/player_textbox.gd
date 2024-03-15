class_name PlayerTextbox
extends MarginContainer

signal finished_displaying

const MAX_WIDTH = 256

var text: String = ""
var letter_index: int = 0

var letter_time: float = 0.03
var space_time: float = 0.06
var punctuaction_time: float = 0.2

@onready var label = $MarginContainer/Label
@onready var timer = $Timer


func display_text(text_to_display: String) -> void:
	text = text_to_display
	label.text = text_to_display

	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)

	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized  # wait for x
		await resized  # wait for y
		custom_minimum_size.y = size.y

	global_position.x -= size.x / 2
	global_position.y -= size.y + 16

	label.text = ""
	_display_letter()


func _display_letter():
	label.text += text[letter_index]

	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return

	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuaction_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)


func _on_timer_timeout():
	_display_letter()
