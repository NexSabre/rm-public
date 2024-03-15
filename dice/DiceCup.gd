extends Node

@onready var inventory: Inventory = Global.dices if Global.dices else Inventory.new()
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()


func _ready() -> void:
	update()


# gdlint:ignore = unused-argument
func _process(delta) -> void:
	inventory = Global.dices
	update()


func update() -> void:
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])
