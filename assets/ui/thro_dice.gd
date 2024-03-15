extends Control

enum Risk {
	NEUTRAL,
	RISKY,
	DANGER,
}

enum Facility {
	CRYOGENIC = 1,
	POWER_PLANT = 2,
	WATER_PUMP = 3,
}

var risk_level: Risk
var _facility: Facility
var _title: String
var _description: String

@onready var btn_cancel: Button = $NinePatchRect/ButtonCancel
@onready var btn_try: Button = $NinePatchRect/ButtonTry

@onready var progress_bar: ProgressBar = $NinePatchRect/ProgressBar
@onready var label_risk_level: Label = $NinePatchRect/LabelRiskLevel
@onready var selected_dice: Sprite2D = $NinePatchRect/ButtonTry/TextureRect

@onready var window: NinePatchRect = $NinePatchRect

@onready var label_title: Label = $NinePatchRect/MarginContainer/VBoxContainer/Label
@onready
var rich_label_description: RichTextLabel = $NinePatchRect/MarginContainer/VBoxContainer/RichTextLabel


func open(
	global_position: Vector2, title: String, description: String, risk_lvl: int = -1, facility: int = 1
) -> void:
	"""Pause, Open the window and set the risk, title and description"""
	window.global_position.x = global_position.x - window.size.x / 2
	window.global_position.y = global_position.y - window.size.y / 2
	window.visible = true
	Global.pause = true

	# Risk
	if risk_lvl == -1:
		risk_lvl = randi_range(0, Risk.size() - 1)
	match risk_lvl:
		0: risk_level = Risk.NEUTRAL
		1: risk_level = Risk.RISKY
		2: risk_level = Risk.DANGER
		_: risk_level = Risk.NEUTRAL
	_set_risk_level(risk_level)

	# Title & Description
	_title = title
	_description = description
	_fill_title_and_description()
	
	# Facility
	_facility = facility

func close() -> void:
	"""Close window and unpause"""
	window.visible = false
	Global.pause = false

func _ready() -> void:
	window.visible = false
	btn_try.disabled = true
	btn_cancel.disabled = false


# gdlint:ignore = unused-argument
func _process(delta) -> void:
	btn_try.disabled = !bool(Global.chosen_val)
	if Global.chosen_val:
		selected_dice.frame = Global.chosen_val + 1
	else:
		selected_dice.frame = 0


func _set_risk_level(rsk_lvl: Risk) -> void:
	"""Modify the theme, base on the Risk Level"""
	match rsk_lvl:
		Risk.NEUTRAL:
			label_risk_level.set("theme_override_colors/font_color", Color.GRAY)
			label_risk_level.text = "safe"
		Risk.RISKY:
			label_risk_level.set("theme_override_colors/font_color", Color.DARK_GOLDENROD)
			label_risk_level.text = "risky"
		Risk.DANGER:
			label_risk_level.set("theme_override_colors/font_color", Color.DARK_RED)
			label_risk_level.text = "danger"


func _fill_title_and_description() -> void:
	"""Fill the title and description"""
	label_title.text = _title
	rich_label_description.text = _description

# MECHANICS
func _throw_mechanics() -> int: 
	"""Base on the energy level, risk and dice choose the best result."""
	var _max: int
	match risk_level:
		Risk.NEUTRAL:
			_max = 2
		Risk.RISKY:
			_max = 4
		Risk.DANGER:
			_max = 6
	var result = randi_range(0, _max) - Global.chosen_val 
	if result >= 0:  # when player lose
		return randf_range(_max*5, 80) * -1 # how many points will be removed from machine
	return 100


# SIGNALS
func _on_button_cancel_pressed() -> void:
	Global.chosen_val = 0
	close()


func _on_button_try_pressed() -> void:
	for x in range(101):
		progress_bar.value = x
		await get_tree().create_timer(0.01).timeout
	var results = _throw_mechanics()
	if results > 0:
		match _facility:
			Facility.CRYOGENIC: 
				Global.change_set('Harvest', 101 - Global.cron_cryogenic_capsule_human_status)
				Global.cron_cryogenic_capsule_human_status = 100
			Facility.POWER_PLANT: 
				Global.change_set('Power', 101 - Global.cron_power_plant_status)
				Global.cron_power_plant_status = 100 
			Facility.WATER_PUMP: 
				Global.change_set('Water', 101 - Global.cron_water_pomp_status)
				Global.cron_water_pomp_status = 100
	else:
		match _facility:
			Facility.CRYOGENIC: 
				Global.change_set('Harvest',  101 - Global.cron_cryogenic_capsule_human_status if results > 0 else results)
				Global.cron_cryogenic_capsule_human_status += results
			Facility.POWER_PLANT: 
				Global.change_set('Power', 101 - Global.cron_power_plant_status if results > 0 else results)
				Global.cron_power_plant_status += results
			Facility.WATER_PUMP: 
				Global.change_set('Water', 101 - Global.cron_water_pomp_status if results > 0 else results)
				Global.cron_water_pomp_status += results
	Global.remove_dice()
	close()
