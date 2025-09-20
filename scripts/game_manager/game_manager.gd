extends Node

@export var coins: int = 0
@export var helth: int = 0
@export var level: int = 1
@export var troops: Array = []
@export var troops_goals: Array = []

var finance: FinanceGame = FinanceGame.new()

func buy_troops() -> void:
	var cost: int = finance.calc_cost_troops(level)
	if coins < cost:
		print("não é possivel comprar mais tropas")
	elif coins >= cost:
		
		print("criar mais tropas")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
