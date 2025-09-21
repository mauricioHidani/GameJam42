extends Node

class_name TroopManager

@export var troops: Array = []
@export var troops_goals: Array = []

@export var troop_instance: PackedScene

func create(goal: Node, level: int) -> void:
	var troop: Troop = Troop.new()
	troop.goal = goal
	if level > 5:
		troop.level += 1
	troops.append(troop)

func remove(troop: Troop) -> void:
	troops.erase(troop)
