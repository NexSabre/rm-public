extends Node

var dialog_lines: Array[String] = []
var current_line_index: int = 0

var text_box
var text_box_position: Vector2

var is_dialog_active: bool = false
var can_advance_line: bool = false

@onready var text_box_scene: Resource = preload("res://scenes/textbox.tscn")
@onready var small_text_box_scene: Resource = preload("res://scenes/player_textbox.tscn")


func show_quick_message(position: Vector2, line: String) -> void:
	if is_dialog_active:
		return

	dialog_lines = [line]
	text_box_position = position

	_show_text_box(small_text_box_scene)

	is_dialog_active = true

	await get_tree().create_timer(2.0).timeout

	text_box.queue_free()

	current_line_index += 1
	if current_line_index >= dialog_lines.size():
		is_dialog_active = false
		current_line_index = 0
		Global.pause = false
		return


func start_dialog(position: Vector2, lines: Array[String]) -> void:
	if is_dialog_active:
		return

	dialog_lines = lines
	text_box_position = position

	_show_text_box(text_box_scene)

	is_dialog_active = true


func _show_text_box(scene: Resource) -> void:
	text_box = scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)

	get_tree().root.add_child(text_box)
	Global.pause = true
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false


func _on_text_box_finished_displaying() -> void:
	can_advance_line = true


func _unhandled_input(event) -> void:
	if (
		(event.is_action_pressed("shoot") or event.is_action_pressed("describe"))
		and is_dialog_active
		and can_advance_line
	):
		text_box.queue_free()

		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			Global.pause = false
			return
		_show_text_box(text_box_scene)
