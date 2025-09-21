extends Node

# === CENAS PARA INSTANCIAR ===
@export var player_scene: PackedScene     # Arraste sua cena do player aqui
@export var tower_scene: PackedScene      # Arraste sua cena da torre aqui
@export var projectile_scene: PackedScene # Arraste sua cena do projétil aqui

# === VARIÁVEIS ===
var player: Area2D = null
var tower: Area2D = null
var screen_size: Vector2

func _ready():
	# Pega o tamanho da tela
	screen_size = get_viewport().get_visible_rect().size
	
	# Spawna tudo
	spawn_player()
	spawn_tower_in_corner()

func spawn_player():
	"""Spawna o player no centro da tela"""
	if player_scene == null:
		print("ERRO: Adicione a cena do player no campo player_scene!")
		return
	
	# Cria o player
	player = player_scene.instantiate()
	add_child(player)
	
	# Coloca no centro da tela
	player.global_position = screen_size / 2
	
	# IMPORTANTE: Adiciona ao grupo para a torre detectar
	player.add_to_group("player_simple")
	
	print("✅ Player spawnado no centro da tela")

func spawn_tower_in_corner():
	"""Spawna uma torre no canto superior direito"""
	if tower_scene == null:
		print("ERRO: Adicione a cena da torre no campo tower_scene!")
		return
	
	# Cria a torre
	tower = tower_scene.instantiate()
	add_child(tower)
	
	# Coloca no canto superior direito (com uma margem de 50 pixels)
	tower.global_position = Vector2(screen_size.x - 50, 50)
	
	# IMPORTANTE: Configura o projétil na torre
	if projectile_scene != null:
		tower.projectile_scene = projectile_scene
		print("✅ Projétil configurado na torre")
	else:
		print("⚠️  AVISO: Adicione a cena do projétil no campo projectile_scene!")
	
	print("✅ Torre spawnada no canto superior direito: " + str(tower.global_position))

# === FUNÇÕES DE TESTE OPCIONAIS ===

func _input(event):
	# Tecla R para reiniciar
	if event.is_action_pressed("ui_accept"):  # ENTER para reiniciar
		restart_test()

func restart_test():
	"""Reinicia o teste"""
	print("=== REINICIANDO TESTE ===")
	
	# Remove objetos existentes
	if player != null and is_instance_valid(player):
		player.queue_free()
	if tower != null and is_instance_valid(tower):
		tower.queue_free()
	
	# Espera um frame e respawna
	await get_tree().process_frame
	spawn_player()
	spawn_tower_in_corner()
