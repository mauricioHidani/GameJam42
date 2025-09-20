extends "res://scripts/Tower.gd"

@export var warrior_scene : PackedScene  # Arraste o WarriorUnit.tscn para cá no Inspetor
@export var warrior_count = 5            # Quantos guerreiros a torre pode ter
@export var warrior_spawn_cooldown = 3.0 # Tempo para gerar um novo guerreiro

var spawned_warriors = []
var is_cooldown = false

func _ready():
	super._ready()

func _process(delta):
	print("Tamanho de enemies_in_range: ", enemies_in_range.size())
	# A Torre Guerreira não ataca diretamente. Ela gerencia suas unidades.
	if not enemies_in_range.is_empty() and not is_cooldown:
		var target = find_target()
		if target:
			spawn_warrior(target)

func spawn_warrior(target_enemy):
	if spawned_warriors.size() >= warrior_count:
		return
	var warrior = warrior_scene.instantiate()
	print("gerreiro criado")
	get_parent().add_child(warrior)
	warrior.global_position = global_position
	warrior.set_target(target_enemy)
	is_cooldown = true
	get_tree().create_timer(warrior_spawn_cooldown).timeout.connect(func(): is_cooldown = false)
