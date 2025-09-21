extends Node

class_name CharacterAnimMove

enum MovementAnimState
{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var moveState: MovementAnimState

func idle(anim: AnimatedSprite2D) -> void:
	match moveState:
		MovementAnimState.UP:
			anim.play("up_idle")
		MovementAnimState.DOWN:
			anim.play("down_idle")
		MovementAnimState.LEFT:
			anim.play("left_idle")
		MovementAnimState.RIGHT:
			anim.play("right_idle")

func run(directions: Vector2, anim: AnimatedSprite2D) -> void:
	if directions.x > 0:
		anim.play("right_walk")
		moveState = MovementAnimState.RIGHT
	elif directions.x < 0:
		anim.play("left_walk")
		moveState = MovementAnimState.LEFT
	elif directions.y > 0:
		anim.play("down_walk")
		moveState = MovementAnimState.DOWN
	elif directions.y < 0:
		anim.play("up_walk")
		moveState = MovementAnimState.UP
