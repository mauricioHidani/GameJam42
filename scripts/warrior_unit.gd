extends CharacterBody2D

@export var speed = 100.0
@export var attack_damage = 20.0
@export var max_health = 50.0

var current_health = 0.0
var target = null
var is_attacking = false

func _ready():
	current_health = max_health
	# Adicione o nó ao grupo para que inimigos possam identificá-lo como "amigo" se necessário
	# add_to_group("allied_units")

	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)

func _physics_process(delta):
	if is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func take_damage(amount):
	current_health -= amount
	if current_health <= 0:
		queue_free()

func set_target(new_target):
	target = new_target

func _on_area_2d_body_entered(body):
	# Supondo que inimigos estejam no grupo "enemies"
	if body.is_in_group("enemies") and body == target:
		# O guerreiro atacou o inimigo
		body.take_damage(attack_damage)
		# Pode adicionar uma animação ou som de ataque aqui
		queue_free() # O guerreiro desaparece após o ataque

func _on_area_2d_body_exited(body):
	if body == target:
		target = null
