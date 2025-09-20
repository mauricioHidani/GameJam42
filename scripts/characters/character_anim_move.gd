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

func idle(head: AnimatedSprite2D, body: AnimatedSprite2D) -> void:
	match moveState:
		MovementAnimState.UP:
			head.play("up_idle")
			body.play("up_idle")
		MovementAnimState.DOWN:
			head.play("down_idle")
			body.play("down_idle")
		MovementAnimState.LEFT:
			head.play("left_idle")
			body.play("left_idle")
		MovementAnimState.RIGHT:
			head.play("right_idle")
			body.play("right_idle")

func walk(directions: Vector2, head: AnimatedSprite2D, body: AnimatedSprite2D) -> void:
	if directions.x > 0:
		head.play("right_walk")
		body.play("right_walk")
		moveState = MovementAnimState.RIGHT
	elif directions.x < 0:
		head.play("left_walk")
		body.play("left_walk")
		moveState = MovementAnimState.LEFT
	elif directions.y > 0:
		head.play("down_walk")
		body.play("down_walk")
		moveState = MovementAnimState.DOWN
	elif directions.y < 0:
		head.play("up_walk")
		body.play("up_walk")
		moveState = MovementAnimState.UP
