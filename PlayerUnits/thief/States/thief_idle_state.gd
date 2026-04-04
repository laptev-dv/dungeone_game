extends State
class_name ThiefIdleState

func enter() -> void:
	character.play_animation("idle")
	character.velocity = Vector2.ZERO

func update(delta: float) -> void:
	# Ищем врага
	var loot = character.find_closest_target("loot")
	var enemy = character.find_closest_target("enemies")
	
	if loot:
		var distance = character.global_position.distance_to(loot.global_position)
		if distance <= character.stats.attack_range:
			var lootingState = ThiefLootingState.new()
			lootingState.target = loot
			state_machine.change_state(lootingState)
		else:
			var moveState = ThiefMoveState.new()
			moveState.target = loot
			state_machine.change_state(moveState)
	elif enemy:
		var distance = character.global_position.distance_to(enemy.global_position)
		if distance <= character.stats.attack_range:
			var attackState = ThiefAttackState.new()
			attackState.target_enemy = enemy
			state_machine.change_state(attackState)
		else:
			var moveState = ThiefMoveState.new()
			moveState.target = enemy
			state_machine.change_state(moveState)
