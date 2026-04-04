extends CharacterBody2D
class_name PlayerBase

# Статистика
@export var stats: CharacterStats

# Компоненты
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var health_bar: ProgressBar = $HealthBar

# Состояния
var current_health: float
var can_attack: bool = true
var is_moving: bool = false
var target_enemy: EnemyBase = null
var target_position: Vector2 = Vector2.ZERO

func _ready():
	# Добавляем в группу для обнаружения врагами
	add_to_group("units")
	
	if stats:
		current_health = stats.max_health
		attack_timer.wait_time = stats.attack_cooldown
		setup_health_bar()

	attack_timer.one_shot = true
	# Подключаем сигнал таймера
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func setup_health_bar():
	health_bar.max_value = stats.max_health
	health_bar.value = current_health
	health_bar.visible = false

func take_damage(amount: float):
	current_health -= amount
	health_bar.value = current_health
	health_bar.visible = true
	
	# Визуальный фидбек
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE
	
	if current_health <= 0:
		die()

func die():
	queue_free()

func move_to_target():
	if not is_moving:
		return
	
	velocity = global_position.direction_to(target_position) * stats.speed
	move_and_slide()
	
	# Обновляем направление спрайта
	if velocity.x != 0:
		sprite_2d.scale.x = sign(velocity.x)
	
	# Проверяем, достигли ли цели
	if global_position.distance_to(target_position) < 10:
		is_moving = false
		velocity = Vector2.ZERO

func attack(enemy: EnemyBase):
	if can_attack and enemy and is_instance_valid(enemy):
		can_attack = false
		enemy.take_damage(stats.damage)
		attack_timer.start()
		
		# Визуальный эффект атаки
		var tween = create_tween()
		tween.tween_property(sprite_2d, "scale", Vector2(1.2, 1.2), 0.1)
		tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.1)

func _on_attack_timer_timeout():
	can_attack = true

func find_closest_enemy() -> EnemyBase:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest: EnemyBase = null
	var min_distance = INF
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest = enemy
	
	return closest

func _physics_process(delta):	
	# Поиск и атака врагов
	target_enemy = find_closest_enemy()
	if target_enemy == null: 
		is_moving = false
		velocity = Vector2.ZERO
		return
	
	var distance = global_position.distance_to(target_enemy.global_position)
	
	if distance >= stats.attack_range:
		target_position = target_enemy.global_position
		is_moving = true
	else:
		is_moving = false
		velocity = Vector2.ZERO
		attack(target_enemy)
		
	# Двигаемся к цели
	move_to_target()
