extends CharacterBody2D

@onready var body_anim: AnimatedSprite2D = $BodyAnimatedSprite2D
@onready var head_anim: AnimatedSprite2D = $HeadAnimatedSprite2D

@export var speed = 180
var directions: Vector2
var moveAnim = CharacterAnimMove.new()

func get_directions() -> void:
	directions.x = Input.get_axis("left", "right")
	directions.y = Input.get_axis("up", "down")
	velocity = directions * speed

func _process(delta: float) -> void:
	get_directions()
	moveAnim.walk(directions, head_anim, body_anim)
	if directions == Vector2.ZERO:
		moveAnim.idle(head_anim, body_anim)
	move_and_slide()
