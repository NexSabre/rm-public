extends Node2D

@onready var elevator_animation: AnimationPlayer = $ElevatorDoor/AnimationPlayer
@onready var player: CharacterBody2D = $player


func _ready() -> void:
	Global.level = 1

	Global.pause = true
	elevator_animation.play("call_elevator")
	await get_tree().create_timer(1.8).timeout
	player.visible = true
	Global.pause = false
	await get_tree().create_timer(2.0).timeout
	elevator_animation.play_backwards("call_elevator")
