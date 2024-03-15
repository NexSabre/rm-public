extends StaticBody2D

const DESCRIBE_LINES: Array[String] = ["Charging station", "I can use it to recharge"]

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var animation: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	interaction_area.interact = Callable(self, "_charge")
	interaction_area.describe = Callable(self, "_describe")


func _describe() -> void:
	DialogManager.start_dialog(global_position, DESCRIBE_LINES)


func _charge() -> void:
	Global.pause = true
	animation.play("charging")
	await get_tree().create_timer(4.0).timeout
	Global.cron_energy_value = 100
	animation.play("idle")
	Global.pause = false
