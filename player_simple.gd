extends Area2D

signal hit(damage)

@export var speed = 400
@export var max_health = 100
var current_health = 100
var screen_size

# === Atributos de tiro ===
@export var projectile_fire: PackedScene
@export var fire_rate := 3.0
@export var projectile_damage := 10
@export var projectile_speed := 500.0
@export var auto_fire_enabled := true

var can_shoot := true
var shoot_cooldown := 2.0

# === Detecção de inimigos ===
var nearby_enemies: Array = []
var auto_fire_timer := 1.0
var current_target = null

func _ready():
	screen_size = get_viewport_rect().size
	hit.connect(_on_hit)
	current_health = max_health
	shoot_cooldown = 1.0 / fire_rate
	
	$range.area_entered.connect(_on_enemy_enter)
	$range.area_exited.connect(_on_enemy_exit)

	add_to_group("player_simple")

func _process(delta):
	handle_movement(delta)

	if Input.is_action_just_pressed("fire"):
		auto_fire_enabled = not auto_fire_enabled
		print("🔁 Auto Fire: " + str(auto_fire_enabled if "Ativado" else "Desativado"))
		
	if auto_fire_enabled:
		auto_shoot(delta)

# === MOVIMENTO ===
func handle_movement(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# === LIMPA INIMIGOS INVÁLIDOS ===
func clean_nearby_enemies():
	for enemy in nearby_enemies.duplicate():
		if not is_instance_valid(enemy):
			nearby_enemies.erase(enemy)

# === SISTEMA DE TIRO ===
func auto_shoot(delta):
	clean_nearby_enemies()

	if nearby_enemies.is_empty():
		current_target = null
		return

	auto_fire_timer -= delta
	if auto_fire_timer <= 0.0 and can_shoot:
		var closest_enemy = get_closest_enemy()
		if closest_enemy:
			current_target = closest_enemy
			shoot(current_target)
			auto_fire_timer = shoot_cooldown

func shoot(enemy):
	can_shoot = false

	var direction : Vector2 = (enemy.global_position - global_position).normalized()
	var projectile := projectile_fire.instantiate()
	projectile.global_position = global_position
	get_parent().add_child(projectile)

	configure_projectile(projectile, direction)
	start_cooldown()

	print("💥 Atirou automaticamente no inimigo ", enemy.name)

func configure_projectile(p, dir):
	if "damage" in p:
		p.damage = projectile_damage
	if "speed" in p:
		p.speed = projectile_speed
	if "direction" in p:
		p.direction = dir
	if p.has_method("set_direction"):
		p.set_direction(dir)
	elif "rotation" in p:
		p.rotation = dir.angle()

func start_cooldown():
	get_tree().create_timer(shoot_cooldown).timeout.connect(func(): can_shoot = true)

# === DETECÇÃO DE INIMIGOS ===
func _on_enemy_enter(area):
	print("Detectado no range: " + area.name)
	if area.is_in_group("enemy") and not nearby_enemies.has(area):
		nearby_enemies.append(area)

func _on_enemy_exit(area):
	if nearby_enemies.has(area):
		nearby_enemies.erase(area)

func get_closest_enemy():
	var closest = null
	var closest_dist := INF
	for enemy in nearby_enemies:
		if not is_instance_valid(enemy):
			continue
		var dist := global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest = enemy
			closest_dist = dist
	return closest

# === VIDA ===
func _on_hit(damage):
	take_damage(damage)

func take_damage(damage):
	current_health -= damage
	print("Player recebeu " + str(damage) + " de dano! Vida restante: " + str(current_health))
	if current_health <= 0:
		die()

func die():
	print("☠️ Player morreu!")
	get_tree().reload_current_scene()

func get_health_percentage():
	return float(current_health) / float(max_health)

func is_alive():
	return current_health > 0

func heal(amount):
	current_health = min(max_health, current_health + amount)
	print("❤️ Player curou " + str(amount) + "! Vida atual: " + str(current_health))
