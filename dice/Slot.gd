extends Panel

var value: int = 0
var mouse_over: bool = false

@onready var background_sprite: Sprite2D = $background
@onready var item_sprite: Sprite2D = $CenterContainer/Panel/item


func update(item: InventoryItem) -> void:
	if !item:
		background_sprite.visible = true
		item_sprite.visible = false
		value = 0
		return
	background_sprite.visible = false
	item_sprite.visible = true
	item_sprite.texture = item.texture
	value = item.value


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if mouse_over:
			Global.chosen_val = value


func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false
