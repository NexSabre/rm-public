extends Node

const CRON_PERIOD: int = 2  # 2 seconds
const CRON_POWER_FACILITY_AGING: float = 0.2
const CRON_WATER_FACILITY_AGING: float = 0.33

const CRON_CRYOGENIC_CAPSULE_HUMAN_AGING: float = 0.44

const DEBUG: bool = true
@export var pause: bool = false
@export var menu: bool = false

var raining: float = 1.0

var dialog: bool = false

var global_position: Vector2
var level: int = 0

var last_update: int = 0

# player
var cron_energy_value: int = 42
var chosen_val: int = 0  # dice 

var cryogenic_cron_value: int = -1
var power_plant_cron_value: int = -1
var water_pump_cron_value: int = -1

# facility
var cron_power_plant_status: float = 100.0
var cron_water_pomp_status: float = 100.0
var cron_cryogenic_capsule_human_status: float = 100.0

var change_name: String = ''
var change_value: int = 0

@onready var dices: Inventory = Inventory.new()

func change_set(name: String, value: float) -> void:
	change_name = "LabelChange%s" % name
	change_value = value

func change_reset() -> void:
	change_name = ""
	change_value = 0.0

func cron_harvest(value_change: int = -1) -> void:
	if Global.pause:
		return
	cron_cryogenic_capsule_human_status += value_change * CRON_CRYOGENIC_CAPSULE_HUMAN_AGING


func cron_facility(value_change: int = -1) -> void:
	if Global.pause:
		return
	cron_power_plant_status += value_change * CRON_POWER_FACILITY_AGING
	cron_water_pomp_status += value_change * CRON_WATER_FACILITY_AGING


func cron_energy(value_change: int = -1) -> void:
	if Global.pause:
		return
	if cron_energy_value <= 5:  # never drop below 5%, instead move slower
		return
	cron_energy_value += value_change


func _debug_print_cron_values() -> void:
	#print("cron_energy_value %s" % cron_energy_value)
	pass

func remove_dice():
	dices._remove(chosen_val)
	chosen_val = 0 
	
	if Global.dices.size() == 0:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
		

# global crone
# gdlint:ignore = unused-argument
func _physics_process(delta):
	if Global.DEBUG:
		_debug_print_cron_values()

	var timestamp: int = Time.get_unix_time_from_system()
	if not last_update:
		last_update = timestamp
	elif (timestamp - last_update) >= CRON_PERIOD:
		last_update = timestamp
		cron_energy()  # just live
		cron_facility()  # operate normally
		cron_harvest()


# gdlint:ignore = unused-argument
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		Global.menu = !Global.menu
		Global.pause = Global.menu
