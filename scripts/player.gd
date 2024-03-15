extends CharacterBody2D

const SPEED: int = 120
const SLOW_SPEED: int = 40

var talk: bool = false
var waked: bool = false
var war_mode: bool = false

@onready var sprite: Sprite2D = $Body
@onready var item: Sprite2D = $Item
@onready var animation: AnimationPlayer = $AnimationPlayer

@onready var Bullet: PackedScene = preload("res://scenes/shoot.tscn")
@onready var pause_label = $GameStatus/Center/VBoxContainer/Label


func _rotate_item() -> void:
	var mouse_global_position: Vector2 = get_global_mouse_position()
	item.rotation = get_angle_to(mouse_global_position)

	if mouse_global_position.x - sprite.global_position.x > 0:
		sprite.flip_h = false
		item.flip_v = false
	else:
		sprite.flip_h = true
		item.flip_v = true


func _shoot() -> void:
	if not war_mode:
		return
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	print($Item.transform)
	bullet.transform = $Item.global_transform


func _show_pause() -> void:
	if Global.menu:
		pause_label.show()
	else:
		pause_label.hide()


# gdlint:ignore = unused-argument
func _physics_process(delta) -> void:
	_show_pause()

	# Global pause and use smthg animation
	if Global.pause:
		Global.global_position = global_position
		if waked:
			return
		waked = true
		animation.play_backwards("wake")
		return
	waked = false
	velocity = Vector2.ZERO

	if Global.menu:
		return

	# rotate item
	_rotate_item()

	# use item
	if Input.is_action_just_pressed("shoot"):
		_shoot()

	if Input.is_action_just_pressed("talk"):
		DialogManager.show_quick_message(global_position, "beep")

	if Input.is_action_pressed("left"):
		velocity.x = -SPEED if Global.cron_energy_value > 10 else -SLOW_SPEED
		animation.play("walk")
		sprite.flip_h = true

	elif Input.is_action_pressed("right"):
		velocity.x = SPEED if Global.cron_energy_value > 10 else SLOW_SPEED
		animation.play("walk")
		sprite.flip_h = false

	elif Input.is_action_just_pressed("war_mode"):
		war_mode = !war_mode
		if war_mode:
			item.show()
		else:
			item.hide()
	else:
		animation.play("ilde_active")

	move_and_slide()
