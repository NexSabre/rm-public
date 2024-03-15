extends Node2D

@onready var weather = $background/GPUParticles2D


func _ready() -> void:
	Global.level = 3
	$player.global_position = Vector2(-180, -16)


# gdlint:ignore = unused-argument
func _physics_process(delta):
	weather.amount_ratio = Global.raining
