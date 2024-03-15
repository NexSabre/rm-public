extends StaticBody2D

const LINES: Array[String] = ["It's auto-piano...", "I can try play on it!"]

@onready var audio_stream: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "_play_piano")
	interaction_area.describe = Callable(self, "_describe_piano")


func _describe_piano() -> void:
	DialogManager.start_dialog(global_position, LINES)


func _play_piano() -> void:
	Global.pause = true
	await get_tree().create_timer(1.0).timeout  # wait for end of pause-animation
	audio_stream.play()

	for x in range(12):
		await get_tree().create_timer(1.0).timeout
		audio_stream.volume_db -= 1
		Global.raining -= 0.1

	Global.pause = false
	audio_stream.stop()
