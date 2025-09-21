extends CharacterBody2D

@onready var anim:		AnimatedSprite2D	= $AnimatedSprite2D
@onready var nav_agent:	NavigationAgent2D	= $NavigationAgent2D
@onready var timer:		Timer				= $Timer

# Character Stats ==============================================================
@export var mas_health:	int			= 100
@export var health:		int			= 25
@export var damage:		int			= 10
@export var speed:		int			= 100
@export var level:		int			= 1
@export var fire_hate:	float		= 1.0
@export var goal:		Node		= null
@export var projectile:	PackedScene

# Usages =======================================================================
var dirs:		Vector2
var can_attack:	bool	= true

# Utils ========================================================================
var animMove:	CharacterAnimMove	= CharacterAnimMove.new()

# Movement Character -----------------------------------------------------------
func _physics_process(delta: float) -> void:
	dirs = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dirs * speed * delta
	animMove.walk(dirs, anim)
	if dirs == Vector2.ZERO:
		animMove.idle(anim)
	move_and_slide()

func go_to_goal() -> void:
	nav_agent.target_position = goal.global_position
	
func _on_timer_timeout() -> void:
	go_to_goal()

# Attack -----------------------------------------------------------------------

func _on_enemy_detect_area_entered(area: Area2D) -> void:
	if !goal and area.is_in_group("tower"):
		goal = area

func attack() -> void:
	var prj_inst
	can_attack = false
	
	prj_inst = projectile.instantiate()
	get_parent().add_to_group("Projectiles", true)
	prj_inst.global_position = global_position
	prj_inst.set_target(goal)
	get_tree().create_timer(1.0 / fire_hate).timeout.connect(func(): can_attack = true)

# Be Damages -------------------------------------------------------------------

func be_damaged(value: int) -> void:
	health -= value
	if health <= 0:
		die()

func die() -> void:
	# Colocar animação de personagem "morrendo"
	print("Unidade morta")
	queue_free()
