extends State
class_name ArcherIdleState

func enter() -> void:
	character.play_animation("idle")
	character.velocity = Vector2.ZERO

func update(delta: float) -> void:
	# Ищем врага
	var enemy = character.find_closest_enemy()
	
	if enemy:
		var distance = character.global_position.distance_to(enemy.global_position)
		if distance <= character.stats.attack_range:
			var attackState = ArcherAttackState.new()
			attackState.target_enemy = enemy
			state_machine.change_state(attackState)
		else:
			var moveState = ArcherMoveState.new()
			moveState.target = enemy
			state_machine.change_state(moveState)
