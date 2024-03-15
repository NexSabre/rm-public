extends StaticBody2D

const LINES: Array[String] = ["Keep on, keeping on!"]

@onready var interaction_area: InteractionArea = $InteractionArea


func _ready() -> void:
	interaction_area.describe = Callable(self, "_describe")


func _describe() -> void:
	DialogManager.start_dialog(global_position, LINES)
