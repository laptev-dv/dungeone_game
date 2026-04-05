extends CharacterBody2D
class_name PlayerBase

# Статистика
@export var stats: CharacterStats

# Компоненты
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent

# Состояния
var current_health: float

func _ready():
	# Добавляем в группу для обнаружения врагами
	add_to_group("units")
	
	if stats:
		current_health = stats.max_health
		attack_timer.wait_time = stats.attack_cooldown
		_setup_health_bar()

func take_damage(amount: float):
	current_health -= amount
	health_bar.value = current_health
	health_bar.visible = true
	
	# Визуальный фидбек
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE
	
	if current_health <= 0:
		_die()

func find_closest_target(groupName: String):
	var targets = get_tree().get_nodes_in_group(groupName)
	var closest = null
	var min_distance = INF
	
	for target in targets:
		var distance = global_position.distance_to(target.global_position)
		if distance < min_distance:
			min_distance = distance
			closest = target
	
	return closest

# Публичные методы для анимаций
func play_animation(anim_name: String, custom_speed: float = 1.0) -> void:
	if animation_player and animation_player.has_animation(anim_name):
		animation_player.play(anim_name, custom_speed)
	else:
		# Заглушка, если анимации нет
		print("Animation not found: ", anim_name)

func stop_animation() -> void:
	if animation_player:
		animation_player.stop()

func is_animation_playing() -> bool:
	return animation_player and animation_player.is_playing()

func _setup_health_bar():
	health_bar.max_value = stats.max_health
	health_bar.value = current_health
	health_bar.visible = false
	
func _die():
	queue_free()
