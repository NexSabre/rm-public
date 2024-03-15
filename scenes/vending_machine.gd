extends StaticBody2D

const LINES: Array[String] = ["Old vending machine...", "full of tokens!"]

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var inventory: Inventory = preload("res://dice/dices/example_inventory.tres")
@onready var item1: InventoryItem = preload("res://dice/dices/one.tres")
@onready var item2: InventoryItem = preload("res://dice/dices/two.tres")
@onready var item3: InventoryItem = preload("res://dice/dices/three.tres")
@onready var item4: InventoryItem = preload("res://dice/dices/four.tres")
@onready var item5: InventoryItem = preload("res://dice/dices/five.tres")
@onready var item6: InventoryItem = preload("res://dice/dices/six.tres")


func _ready() -> void:
	interaction_area.interact = Callable(self, "_interact")
	interaction_area.describe = Callable(self, "_describe")


func _describe() -> void:
	DialogManager.start_dialog(global_position, LINES)


func generate_new_dices() -> Inventory:
	var dices = {
		1: item1,
		2: item2,
		3: item3,
		4: item4,
		5: item5,
		6: item6,
	}
	inventory.items = []
	for r in range(6):
		inventory.items.append(dices[randi_range(1, 6)])
	return inventory


func _interact() -> void:
	Global.dices = generate_new_dices()
