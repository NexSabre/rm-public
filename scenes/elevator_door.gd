extends StaticBody2D

const LINES: Array[String] = ["It's elevator", "I can go to other rooms."]

var go_to_floor: int = -1

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var elevator_sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label


func _ready() -> void:
	interaction_area.interact = Callable(self, "_call_elevator")
	interaction_area.describe = Callable(self, "_describe")


func _describe() -> void:
	DialogManager.start_dialog(global_position, LINES)


# gdlint:ignore = unused-argument
func _unhandled_key_input(event) -> void:
	if Input.is_action_just_pressed("number_1"):
		elevator_sprite.frame = 0
		go_to_floor = 1
		if not Global.level == 1:
			get_tree().change_scene_to_file("res://rooms/reactor_room.tscn")
	elif Input.is_action_just_pressed("number_2"):
		go_to_floor = 2
		if not Global.level == 2:
			get_tree().change_scene_to_file("res://rooms/water_room.tscn")
	elif Input.is_action_just_pressed("number_3"):
		go_to_floor = 3
		if not Global.level == 3:
			get_tree().change_scene_to_file("res://scenes/world.tscn")
	elif Input.is_action_just_pressed("number_0"):  # cancel
		animation.play_backwards("call_elevator")
		go_to_floor = 0

	if go_to_floor >= 0:
		go_to_floor = -1  # reset
		label.hide()
		InteractionManager.can_interact = true
		Global.pause = false


func _fill_label() -> void:
	label.global_position.x = $InteractionArea.global_position.x
	label.global_position.y = $InteractionArea.global_position.y + 54
	label.text = "1. ENERGY STATION\n2.\tWATER PUMP STATION\n3.\tMAIN FLOOR"


func _call_elevator() -> void:
	Global.pause = true
	_fill_label()
	animation.play("call_elevator")
	await get_tree().create_timer(1.6).timeout
	label.show()
