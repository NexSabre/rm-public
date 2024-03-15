extends StaticBody2D

const LINES: Array[String] = ["Rusty water pomp", "I need to keep it running..."]

@onready var interaction_area: InteractionArea = $InteractionArea


func _ready() -> void:
	interaction_area.interact = Callable(self, "_play_piano")
	interaction_area.describe = Callable(self, "_describe_piano")


func _describe_piano() -> void:
	DialogManager.start_dialog(global_position, LINES)


func _play_piano() -> void:
	Global.pause = true
	print("play_piano for 2sec")
	print(Global.raining)
	for x in range(10):
		await get_tree().create_timer(1.0).timeout
		Global.raining -= 0.1
		print(Global.raining)
		Global.pause = false
