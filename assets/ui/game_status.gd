extends CanvasLayer

@onready var energy_bar_label: Label = $Bottom/HBoxContainer/VBoxContainer/Label
@onready var energy_bar: ProgressBar = $Bottom/HBoxContainer/VBoxContainer/ProgressBar

@onready var power_plant_status_bar: ProgressBar = $Bottom/HBoxContainer/VBoxContainer3/ProgressBar
@onready var water_pump_status_bar: ProgressBar = $Bottom/HBoxContainer/VBoxContainer2/ProgressBar
@onready var cryogenic_status_bar: ProgressBar = $Bottom/HBoxContainer/VBoxContainer4/ProgressBar

# change labels
@onready var enery_label_change: Label = $Bottom/HBoxContainer/VBoxContainer/LabelChangeEnergy
@onready var water_pump_label_change: Label = $Bottom/HBoxContainer/VBoxContainer2/LabelChangeWater
@onready var power_plant_label_change: Label = $Bottom/HBoxContainer/VBoxContainer3/LabelChangePower
@onready var cryogenic_label_change: Label = $Bottom/HBoxContainer/VBoxContainer4/LabelChangeHarvest

# gdlint:ignore = unused-argument
func _process(delta: float) -> void:
	energy_bar.value = Global.cron_energy_value
	power_plant_status_bar.value = Global.cron_power_plant_status
	water_pump_status_bar.value = Global.cron_water_pomp_status
	cryogenic_status_bar.value = Global.cron_cryogenic_capsule_human_status

	for bar in [energy_bar, water_pump_status_bar, power_plant_status_bar, cryogenic_status_bar]:
		if bar.value > 40:
			bar.get("theme_override_styles/fill").bg_color = Color.WEB_GRAY
		elif 11 < bar.value and bar.value <= 40:
			bar.get("theme_override_styles/fill").bg_color = Color.DARK_GOLDENROD
		else:
			bar.get("theme_override_styles/fill").bg_color = Color.DARK_RED
	show_change()  # show change for specific field
	
func show_change() -> void:
	"""Present a change of the value after the event"""
	for label in [enery_label_change, power_plant_label_change, water_pump_label_change, cryogenic_label_change]:
		if Global.change_name == label.name:
			label.text = "UP +%s" % Global.change_value if Global.change_value > 0 else "DOWN %s" % Global.change_value
			label.set("theme_override_colors/font_color", Color.WEB_GREEN if Global.change_value > 0 else Color.DARK_RED)
			await get_tree().create_timer(5.0).timeout
			Global.change_value = 0.0
			Global.change_name = ""
			label.set("theme_override_colors/font_color", Color.GRAY)
			label.text = "..."
			
