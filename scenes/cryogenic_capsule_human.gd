extends StaticBody2D

const events = [["Broken pump", "The fluid pump was broken. Coolant is everywhere!"], 
["Pipe is clogged", "The food pipe is clogged, harvest can died!"]]


var interaction_open: bool = false

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var status_bar: ProgressBar = $StatusBar
@onready var throw_dice: Control = $ThroDice


func _ready() -> void:
	interaction_area.interact = Callable(self, "_interact")
	animation.play("idle")

	status_bar.value = Global.cron_cryogenic_capsule_human_status


# gdlint:ignore = unused-argument
func _process(delta: float) -> void:
	status_bar.value = Global.cron_cryogenic_capsule_human_status


func _interact() -> void:
	if not interaction_open:
		var _event = events[randi_range(0, events.size() - 1)]
		throw_dice.open(global_position, _event[0], _event[1], -1)
	else:
		throw_dice.close()
		animation.play("interact")
	interaction_open = !interaction_open
