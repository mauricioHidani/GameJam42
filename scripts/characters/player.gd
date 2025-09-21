extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var level: int = 1
@export var health: int = 100
@export var speed: float = 10

var directions: Vector2
var moveAnim = CharacterAnimMove.new()

func get_directions() -> void:
	directions.x = Input.get_axis("left", "right")
	directions.y = Input.get_axis("up", "down")
	velocity = directions * speed

func _process(delta: float) -> void:
	get_directions()
	moveAnim.run(directions, anim)
	if directions == Vector2.ZERO:
		moveAnim.idle(anim)
	move_and_slide()

func die():
	print("You die")

func damage(value: int):
	health -= value
	if health <= 0:
		die()
