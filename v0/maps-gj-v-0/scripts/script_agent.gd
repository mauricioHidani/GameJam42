extends CharacterBody2D

enum MovementAnimState
{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var speed: int = 100
@export var target: Node = null
@onready var navagent: NavigationAgent2D = $NavigationAgent2D
@onready var body_anim: AnimatedSprite2D = $AnimatedSprite2D
@export var evasion_velocity: float = 250.0 

var is_avoiding: bool = false 
var evasion_vector: Vector2 = Vector2.ZERO
var directions: Vector2
var last_anim_state = MovementAnimState.DOWN

func _ready():
		add_to_group("allies")

func _physics_process(delta: float) -> void:
	if is_avoiding:
		velocity = evasion_vector * evasion_velocity
		walk()
	directions = to_local(navagent.get_next_path_position()).normalized()
	velocity = directions * speed
	if directions == Vector2.ZERO or navagent.is_navigation_finished():
		idle()
	else:
		walk()
	move_and_slide()

func go_to_target() -> void:
	if target != null:
		navagent.target_position = target.global_position

func _on_timer_timeout() -> void:
	go_to_target()

func walk() -> void:
		if directions.y < 0:
			body_anim.play("walk_up")
			last_anim_state = MovementAnimState.UP
			
		elif directions.y > 0:
			body_anim.play("walk_down")
			last_anim_state = MovementAnimState.DOWN
			
		elif directions.x < 0:
			body_anim.play("walk_side")
			body_anim.flip_h = true
			last_anim_state = MovementAnimState.LEFT
			
		elif directions.x > 0:
			body_anim.play("walk_side")
			body_anim.flip_h = false
			last_anim_state = MovementAnimState.RIGHT
		
func idle() -> void:
		match last_anim_state:
			MovementAnimState.UP:
				body_anim.play("idle_up")
			MovementAnimState.DOWN:
				body_anim.play("idle_down")
			MovementAnimState.LEFT, MovementAnimState.RIGHT:
				body_anim.play("idle_side")
