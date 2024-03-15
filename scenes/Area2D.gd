extends Area2D

var speed: int = 750


func _physics_process(delta):
	var mouse_global_position: Vector2 = get_global_mouse_position()
	#rotation = get_angle_to(mouse_global_position)
	position += transform.x * speed * delta


func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
