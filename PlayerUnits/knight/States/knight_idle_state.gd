extends State
class_name KnightIdleState

func enter() -> void:
	character.play_animation("idle")
	character.velocity = Vector2.ZERO

func update(delta: float) -> void:
	# Ищем врага
	var enemy = character.find_closest_enemy()
	
	if enemy:
		var distance = character.global_position.distance_to(enemy.global_position)
		if distance <= character.stats.attack_range:
			var attackState = KnightAttackState.new()
			attackState.target_enemy = enemy
			state_machine.change_state(attackState)
		else:
			var moveState = KnightMoveState.new()
			moveState.target = enemy
			state_machine.change_state(moveState)
