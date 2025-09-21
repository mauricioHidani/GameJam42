extends Area2D

@export var attack_range = 450.0
@export var attack_rate = 1.0
@export var projectile_scene: PackedScene
@export var max_health = 100.0

var current_health = 100
var enemies_in_range = []
var can_attack = true

signal hit_tower(damage)

func _ready():
	current_health = max_health
	add_to_group("enemy")  # Importante: grupo certo para ser detectado

	# Ajusta visualmente e logicamente o Range
	var range_area = $Range
	var shape = range_area.get_node("CollisionShape2D").shape
	if shape is CircleShape2D:
		shape.radius = attack_range

	# Conecta sinais de detecção de inimigos
	$Range.area_entered.connect(_on_range_area_entered)
	$Range.area_exited.connect(_on_range_area_exited)

func _process(delta):
	if can_attack and not enemies_in_range.is_empty():
		var target = get_closest_enemy()
		if target:
			attack(target)

# === DETECÇÃO DE INIMIGOS ===
func _on_range_area_entered(area):
	if area.is_in_group("player_simple") and not enemies_in_range.has(area):
		enemies_in_range.append(area)
		print("✅ Inimigo detectado: ", area.name)

func _on_range_area_exited(area):
	if area in enemies_in_range:
		enemies_in_range.erase(area)

# === SISTEMA DE ATAQUE ===
func attack(target):
	can_attack = false

	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	get_parent().add_child(projectile)

	if projectile.has_method("set_target"):
		projectile.set_target(target)

	print("💥 Torre ", name, " atirou em ", target.name)

	get_tree().create_timer(1.0 / attack_rate).timeout.connect(func():
		can_attack = true
	)

func get_closest_enemy():
	var closest = null
	var closest_dist = INF
	for enemy in enemies_in_range:
		if not is_instance_valid(enemy):
			continue
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest = enemy
			closest_dist = dist
	return closest

# === RECEBER DANO ===
func _on_hit_tower(damage):
	take_damage(damage)

func take_damage(damage):
	current_health -= damage
	print("⚠️ Torre ", name, " recebeu ", damage, " de dano. Vida: ", current_health)
	if current_health <= 0:
		destroy_tower()

func destroy_tower():
	print("☠️ Torre ", name, " destruída!")
	queue_free()
