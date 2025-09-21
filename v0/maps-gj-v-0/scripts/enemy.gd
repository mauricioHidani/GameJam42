extends CharacterBody2D

signal hit_soldier(damage)

@export var speed = 50.0      # Velocidade de movimento do inimigo
@export var max_health = 50.0 # Vida máxima do inimigo
@export var gold_on_death = 10 # Ouro que o jogador ganha ao destruir o inimigo
@export var damage_to_player = 1 # Dano que o inimigo causa à base se a alcançar

var current_health = 0.0
var path_points = [] # Pontos do caminho que o inimigo deve seguir
var current_path_index = 0

func _ready():
	current_health = max_health
	# Se você tiver um ProgressBar para vida, inicialize-o aqui
	if $ProgressBar:
		$ProgressBar.max_value = max_health
		$ProgressBar.value = current_health
	
	add_to_group("enemy")

func _physics_process(delta):
	if not path_points.is_empty() and current_path_index < path_points.size():
		var target_position = path_points[current_path_index]
		var direction = (target_position - global_position).normalized()
		
		velocity = direction * speed
		move_and_slide()
		
		# Verifica se o inimigo chegou perto o suficiente do ponto atual do caminho
		if global_position.distance_to(target_position) < 5: # Um pequeno limiar
			current_path_index += 1
			if current_path_index >= path_points.size():
				# Inimigo alcançou o final do caminho (a base do jogador)
				reach_end_of_path()
	else:
		# Se não há caminho definido, o inimigo não se move
		velocity = Vector2.ZERO
		move_and_slide()

func take_damage(amount):
	current_health -= amount
	print("Inimigo recebeu ", amount, " de dano. Vida restante: ", current_health)
	if $ProgressBar:
		$ProgressBar.value = current_health

	if current_health <= 0:
		die()

func die():
	# Adicionar efeitos de morte (animação, som, partículas)
	print("Inimigo destruído! Ganhos: ", gold_on_death, " ouro.")
	# Emitir um sinal para a cena principal para adicionar ouro ao jogador
	# get_parent().emit_signal("enemy_died", gold_on_death) # Você precisaria definir esse sinal na cena pai
	queue_free() # Remove o inimigo da cena

func reach_end_of_path():
	print("Inimigo alcançou o fim do caminho! Dano à base: ", damage_to_player)
	# Emitir um sinal para a cena principal para causar dano à base do jogador
	# get_parent().emit_signal("base_damaged", damage_to_player)
	queue_free() # Remove o inimigo

# Função para definir o caminho que o inimigo deve seguir
func set_path(path_data: Array):
	path_points = path_data
	current_path_index = 0

func _on_hit_soldier(damage: Variant) -> void:
	take_damage(damage)
