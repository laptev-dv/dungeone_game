extends State
class_name KnightAttackState

var target_enemy: EnemyBase

var _attack_cooldown: float

func enter() -> void:
	_attack_cooldown = character.stats.attack_cooldown
	character.velocity = Vector2.ZERO
	# Атакуем сразу при входе
	_attack()

func update(delta: float) -> void:
	if _attack_cooldown > 0:
		_attack_cooldown -= delta
		return
	
	# Проверяем цель
	if not target_enemy or not is_instance_valid(target_enemy):
		var idleState = KnightIdleState.new()
		state_machine.change_state(idleState)
		return
	
	# Проверяем дистанцию
	var distance = character.global_position.distance_to(target_enemy.global_position)
	if distance > character.stats.attack_range:
		var moveState = KnightMoveState.new()
		moveState.target = target_enemy
		state_machine.change_state(moveState)
		return
	
	_attack()

func _attack() -> void:
	if target_enemy and is_instance_valid(target_enemy):
		target_enemy.take_damage(character.stats.damage)
		_attack_cooldown = character.stats.attack_cooldown
		character.play_animation("attack")
