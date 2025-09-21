extends CharacterBody2D

class_name Troop

@export var id: int = 0
@export var speed: int = 100
@export var goal: Node = null
@export var helth: int = 100
@export var level: int = 1

@onready var navagent: NavigationAgent2D = $NavigationAgent2D
@onready var body_anim: AnimatedSprite2D = $BodyAnimatedSprite2D
@onready var head_anim: AnimatedSprite2D = $HeadAnimatedSprite2D

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
	navagent.target_position = goal.global_position

func _on_timer_timeout() -> void:
	go_to_target()
