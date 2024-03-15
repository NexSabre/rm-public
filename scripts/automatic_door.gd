extends StaticBody2D

const LINES: Array[String] = ["These are BIG BLAST DOORS", "I wonder what's behind them..."]

@export var open: bool = false

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var door_sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	interaction_area.describe = Callable(self, "_describe")
	interaction_area.interact = Callable(self, "_toogle_door")
	door_sprite.frame = 5 if open else 0  # closed door


func _describe() -> void:
	DialogManager.start_dialog(global_position, LINES)


func _toogle_door() -> void:
	if not open:  # if closed
		open = true
		animation.play("toogle")
		door_sprite.frame = 5  # opened door
		interaction_area.action_name = "close"
		collision.disabled = true
		return

	# if open
	open = false
	animation.play_backwards("toogle")
	door_sprite.frame = 0  # closed door
	interaction_area.action_name = "open"
	collision.disabled = false
