extends Node2D

@export var attack_range = 150.0  # Alcance de ataque
@export var attack_rate = 1.0     # Taxa de ataque (ataques por segundo)
@export var projectile_scene : PackedScene # Cena do projétil

var enemies_in_range = []
var can_attack = true
@export var max_health = 100.0    # Vida máxima da torre
var current_health = 0.0

func _ready():
	# Ajusta o tamanho da área de detecção
	current_health = max_health
	var collision_shape = $Area2D/CollisionShape2D.shape
	if collision_shape is CircleShape2D:
		collision_shape.radius = attack_range
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)

func _process(delta):
	if not enemies_in_range.is_empty() and can_attack:
		var target = find_target()
		if target:
			attack(target)
			
func _on_area_2d_body_entered(body):
	# Supondo que inimigos tenham um grupo "enemies"
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_area_2d_body_exited(body):
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)

func find_target():
	# Retorna o primeiro inimigo na lista.
	# Você pode implementar lógicas mais complexas aqui
	# (por exemplo, o inimigo mais próximo, o mais forte, etc.).
	return enemies_in_range[0] if not enemies_in_range.is_empty() else null

func attack(target):
	can_attack = false
	# Instancia o projétil na posição da torre
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	# Faz o projétil mirar no inimigo
	projectile.set_target(target)
	# Espera o tempo de recarga
	get_tree().create_timer(1.0 / attack_rate).timeout.connect(func(): can_attack = true)
	
func take_damage(amount):
	# Reduz a vida da torre
	current_health -= amount
	# Se a vida chegar a zero ou menos, destrói a torre
	if current_health <= 0:
		destroy_tower()
func destroy_tower():
	# Adicione efeitos de destruição aqui (som, animação, etc.)
	print("Torre destruída!")
	queue_free()
