extends State
class_name ThiefLootingState

var target: Loot

var _loot_cooldown: float

func enter() -> void:
	_loot_cooldown = character.stats.attack_cooldown
	character.velocity = Vector2.ZERO
	# Атакуем сразу при входе
	_loot()

func update(delta: float) -> void:
	if _loot_cooldown > 0:
		_loot_cooldown -= delta
		return
	
	# Проверяем цель
	if not target or not is_instance_valid(target):
		var idleState = ThiefIdleState.new()
		state_machine.change_state(idleState)
		return
	
	_loot()

func _loot() -> void:
	if target and is_instance_valid(target):
		target.loot(character.stats.damage)
		_loot_cooldown = character.stats.attack_cooldown
		character.play_animation("loot")
