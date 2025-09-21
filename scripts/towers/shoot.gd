extends Area2D

@export var speed = 400.0
@export var damage = 10.0

var target = null

func _process(delta):
	if target and is_instance_valid(target):
		# Move o projétil em direção ao alvo
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
	else:
		queue_free()

func set_target(new_target):
	target = new_target

func _on_body_entered(body: Node2D) -> void:
	if body == target and body.is_in_group("enemies"):
		body.take_damage(damage)
		queue_free()
