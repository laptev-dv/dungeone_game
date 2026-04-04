extends CharacterBody2D
class_name EnemyBase

@export var stats: CharacterStats
@export var detection_range: float = 150.0
@export var experience_reward: int = 10

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var health_bar: ProgressBar = $HealthBar

var current_health: float
var can_attack: bool = true
var target_player: PlayerBase = null
var is_moving: bool = false

func _ready():
	add_to_group("enemies")
	
	if stats:
		current_health = stats.max_health
		health_bar.max_value = stats.max_health
		health_bar.value = current_health
		health_bar.visible = false
		attack_timer.wait_time = stats.attack_cooldown

	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func take_damage(amount: float):
	current_health -= amount
	health_bar.value = current_health
	health_bar.visible = true
	
	modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	modulate = Color.WHITE
	
	if current_health <= 0:
		die()

func die():
	queue_free()

func find_target() -> PlayerBase:
	var players = get_tree().get_nodes_in_group("units")
	var closest: PlayerBase = null
	var min_distance = INF
	
	for player in players:
		var distance = global_position.distance_to(player.global_position)
		if distance <= detection_range and distance < min_distance:
			min_distance = distance
			closest = player
	
	return closest

func move_towards_target(target: PlayerBase):
	is_moving = true
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * stats.speed
	move_and_slide()
	
	if velocity.x != 0:
		sprite_2d.scale.x = sign(velocity.x)

func attack(player: PlayerBase):
	if can_attack and player and is_instance_valid(player):
		can_attack = false
		player.take_damage(stats.damage)
		attack_timer.start()

func _physics_process(delta):
	target_player = find_target()
	
	if target_player:
		var distance = global_position.distance_to(target_player.global_position)
		
		if distance <= stats.attack_range:
			is_moving = false
			velocity = Vector2.ZERO
			attack(target_player)
		else:
			move_towards_target(target_player)
	else:
		is_moving = false
		velocity = Vector2.ZERO

func _on_attack_timer_timeout():
	can_attack = true
