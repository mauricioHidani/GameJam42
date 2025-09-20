extends Node

class_name FinanceGame

@export var coins: int = 0
@export var growth_cost: float = 0.4

var init_cost_troops: int = 10
var init_cost_life: int = 100

func calc_cost_troops(level: int) -> int:
	return init_cost_troops * level * growth_cost

func calc_cost_life(level: int) -> int:
	return init_cost_life * level * growth_cost
