class_name InteractionArea
extends Area2D

@export var action_name: String = "interact"

var interact: Callable = func(): pass
var describe: Callable = func(): pass


# gdlint:ignore = unused-argument
func _on_body_entered(body):
	InteractionManager.register_area(self)


# gdlint:ignore = unused-argument
func _on_body_exited(body):
	InteractionManager.unregister_area(self)
