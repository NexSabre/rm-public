extends Node2D

const BASE_TEXT: String = "[E] to "
const BASE_TEXT_FOR_QUESTION: String = "[Q] to investigate"

var active_areas: Array[InteractionArea] = []
var can_interact: bool = true

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label
@onready var label2 = $Label2


func register_area(area: InteractionArea) -> void:
	active_areas.push_back(area)


func unregister_area(area: InteractionArea) -> void:
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


# gdlint:ignore = unused-argument
func _process(delta) -> void:
	if active_areas.size() > 0 && can_interact && !Global.pause:
		active_areas.sort_custom(_sort_by_distance_to_player)
		var area = active_areas[0]
		label.text = BASE_TEXT + area.action_name
		label.global_position = area.global_position
		label.global_position.y -= 56  # px
		label.global_position.x -= label.size.x / 2
		label.show()

		label2.text = BASE_TEXT_FOR_QUESTION
		label2.global_position = area.global_position
		label2.global_position.y -= 72  # px
		label2.global_position.x -= label2.size.x / 2
		label2.show()
	else:
		label.hide()
		label2.hide()


func _sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea) -> bool:
	if not player:
		player = get_tree().get_first_node_in_group("player")
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _input(event) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			label2.hide()

			await active_areas[0].interact.call()

			can_interact = true
	if event.is_action_pressed("describe") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			label2.hide()

			await active_areas[0].describe.call()

			can_interact = true
