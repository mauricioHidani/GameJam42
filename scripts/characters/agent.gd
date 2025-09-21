extends CharacterBody2D

@export var speed:		int					= 100
@export var target:		Node				= null
@onready var navagent:	NavigationAgent2D 	= $NavigationAgent2D
@onready var body_anim:	AnimatedSprite2D 	= $BodyAnimatedSprite2D
@onready var head_anim:	AnimatedSprite2D 	= $HeadAnimatedSprite2D

@export var max_health:		int		= 100
@export var current_health:	float	= 25
@export var hit_damage	 			:= 10
@export var group_hit:		String	= "tower"
@export var hit_dist:		float	= 10.0
@export var cooldown				:= 2.0
var can_hit:		bool		= true

var directions: Vector2
var moveAnim = CharacterAnimMove.new()

func _physics_process(delta: float) -> void:
	directions = to_local(navagent.get_next_path_position()).normalized()
	velocity = directions * speed * delta
	moveAnim.walk(directions, head_anim, body_anim)
	if directions == Vector2.ZERO:
		moveAnim.idle(head_anim, body_anim)
	move_and_slide()

func go_to_target() -> void:
	if global_position.distance_to(navagent.global_position) <= hit_dist:
		navagent.target_position = global_position
	else:
		navagent.target_position = target.global_position

func _on_timer_timeout() -> void:
	go_to_target()
func take_damage(damage):
	current_health -= damage
	print("Recebeu " + str(damage) + " de dano! Vida restante: " + str(current_health))
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

func _on_range_area_entered(area: Area2D) -> void:
	if can_hit and area.is_in_group(group_hit):
		area.take_damage(hit_damage)
		can_hit = false
		_start_cooldown()

func _start_cooldown() -> void:
	await get_tree().create_timer(cooldown).timeout
	can_hit = true
