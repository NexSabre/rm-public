class_name Inventory
extends Resource

@export var items: Array[InventoryItem]

func size() -> int:
	"""Return the number of dices available to use"""
	var count: int = 0
	for i in items:
		if i and i.value > 0: 
			count += 1
	return count

func _remove(val: int) -> void:
	"""Remove the first dice with given value"""
	var pos: int = 0
	for i in items:
		if i && i.value == val:
			items[pos] = null
			break
		pos += 1
