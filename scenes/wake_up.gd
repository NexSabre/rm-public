extends Node2D


@onready var label_wake_up: Label = $LabelWakeUp
@onready var label_iteration: Label = $LabelIteration

func print_txt(label: Label, text: String, timeout: float = 0.2) -> void:
	var full_text: String = ""
	for t in text:
		full_text += t
		label.text = full_text
		await get_tree().create_timer(0.2).timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_txt(label_wake_up, 'Wake up,\nresource!')
	print_txt(label_iteration, 'Iteration #2137', 0.1)
	await get_tree().create_timer(6.0).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
