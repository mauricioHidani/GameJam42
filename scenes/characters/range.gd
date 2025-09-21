extends Area2D

signal hit(damage)

@export var speed = 400
@export var max_health = 100
var current_health = 100
var screen_size 

# === SISTEMA DE TIRO ===
@export var projectile_fire: PackedScene
@export var fire_rate: float = 3.0
@export var projectile_damage: int = 25
@export var projectile_speed: float = 500.0

var can_shoot: bool = true
var shoot_cooldown: float

# === AUTO FIRE AO DETECTAR INIMIGOS ===
@export var auto_fire_enabled: bool = true
var nearby_enemies: Array = []
var auto_fire_timer := 0.0

func _ready():
	screen_size = get_viewport_rect().size
	hit.connect(_on_hit)
	current_health = max_health
	add_to_group("player_simple")
	
	shoot_cooldown = 1.0 / fire_rate
	
	$DetectionArea.body_entered.connect(_on_DetectionArea_body_entered)
	$DetectionArea.body_exited.connect(_on_DetectionArea_body_exited)
	
	print("✅ Player configurado - Fire Rate: " + str(fire_rate) + " tiros/seg")

# === TIRO EM ALVO (INIMIGO MAIS PRÓXIMO) ===

func _physics_process(delta):
	handle_movement(delta)
	handle_aiming()

	if auto_fire_enabled:
		handle_enemy_auto_fire(delta)

func handle_enemy_auto_fire(delta):
	if nearby_enemies.is_empty():
		return

	auto_fire_timer -= delta
	if auto_fire_timer <= 0.0 and can_shoot:
		var target = get_nearest_enemy()
		if target:
			shoot_at_target(target)
			auto_fire_timer = shoot_cooldown

func shoot_at_target(target):
	var direction = (target.global_position - global_position).normalized()
	if not can_shoot or projectile_fire == null:
		return

	can_shoot = false

	var projectile = projectile_fire.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position

	setup_projectile(projectile, direction)
	print("🎯 Player atirou no inimigo automaticamente!")

	start_shoot_cooldown()

func get_nearest_enemy():
	var nearest = null
	var nearest_dist = INF
	for enemy in nearby_enemies:
		if not is_instance_valid(enemy):
			continue
		var dist = global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest = enemy
			nearest_dist = dist
	return nearest

func _on_DetectionArea_body_entered(body):
	if body.is_in_group("enemy"):
		nearby_enemies.append(body)

func _on_DetectionArea_body_exited(body):
	if body in nearby_enemies:
		nearby_enemies.erase(body)

# === CONFIGURAÇÃO DO PROJÉTIL ===

func setup_projectile(projectile, direction: Vector2):
	if "damage" in projectile:
		projectile.damage = projectile_damage

	if "speed" in projectile:
		projectile.speed = projectile_speed

	if "direction" in projectile:
		projectile.direction = direction

	if projectile.has_method("set_direction"):
		projectile.set_direction(direction)
	elif "rotation" in projectile:
		projectile.rotation = direction.angle()

	if projectile.has_method("set_target"):
		var fake_target_pos = global_position + direction * 1000
		var fake_target = Node2D.new()
		fake_target.global_position = fake_target_pos
		get_parent().add_child(fake_target)
		get_tree().create_timer(0.1).timeout.connect(func(): fake_target.queue_free())
		projectile.set_target(fake_target)

func start_shoot_cooldown():
	get_tree().create_timer(shoot_cooldown).timeout.connect(func(): can_shoot = true)

# === MOVIMENTO E MIRA ===

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

func handle_aiming():
	var mouse_pos = get_global_mouse_position()
	var direction_to_mouse = (mouse_pos - global_position).normalized()

	if direction_to_mouse.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func get_facing_direction() -> Vector2:
	if $AnimatedSprite2D.flip_h:
		return Vector2.LEFT
	else:
		return Vector2.RIGHT

# === VIDA DO PLAYER ===

func _on_hit(damage):
	take_damage(damage)

func take_damage(damage):
	current_health -= damage
	print("Player recebeu " + str(damage) + " de dano! Vida: " + str(current_health))
	if current_health <= 0:
		die()

func die():
	print("☠️ Player morreu!")
	get_tree().reload_current_scene()

func heal(amount):
	current_health = min(max_health, current_health + amount)
	print("Player curou " + str(amount) + "! Vida: " + str(current_health))

func get_health_percentage():
	return float(current_health) / float(max_health)

func is_alive():
	return current_health > 0
