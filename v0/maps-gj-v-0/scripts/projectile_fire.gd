extends Area2D

# === CONFIGURAÇÕES EXPORTADAS ===
@export var speed = 100.0    # Velocidade do projétil (pixels por segundo)
@export var damage = 1.0     # Dano que o projétil causa ao acertar o player

# === VARIÁVEIS DE CONTROLE ===
var target = null            # Referência do alvo (player) que o projétil deve acertar
var direction = Vector2.ZERO # Direção em que o projétil se move (vetor normalizado)

func _ready():
	# === CONFIGURAÇÃO INICIAL ===
	# Conecta o sinal para detectar quando o projétil colide com algo
	area_entered.connect(_on_area_entered)
	
	# === SISTEMA DE SEGURANÇA ===
	# Auto-destruir após 5 segundos se não acertar nada
	# Isso evita que projéteis fiquem voando para sempre pela cena
	get_tree().create_timer(5.0).timeout.connect(func(): queue_free())

# === SISTEMA DE MIRA ===

func set_target(new_target):
	# Define o alvo que o projétil deve perseguir
	# Esta função é chamada pela torre quando dispara o projétil
	
	target = new_target
	if target:
		# Calcula a direção do projétil até o alvo
		direction = (target.global_position - global_position).normalized()
		
		# Rotaciona o sprite do projétil para apontar na direção correta
		# angle() converte o vetor direção em um ângulo em radianos
		rotation = direction.angle()

# === MOVIMENTO DO PROJÉTIL ===

func _physics_process(delta):
	# Executado a cada frame para mover o projétil
	
	if direction != Vector2.ZERO:  # Se temos uma direção válida
		# Move o projétil na direção calculada
		# delta garante movimento suave independente do framerate
		global_position += direction * speed * delta

# === SISTEMA DE COLISÃO E DANO ===

func _on_area_entered(area):
	if area.is_in_group("enemy"): 
		# === APLICAÇÃO DE DANO ===
		if area.has_signal("hit_soldier"):
			area.hit_soldier.emit(damage)
		# === DESTRUIÇÃO DO PROJÉTIL ===
		queue_free()
