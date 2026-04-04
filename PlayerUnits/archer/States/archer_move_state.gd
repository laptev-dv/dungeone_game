extends State
class_name ArcherMoveState

var target: EnemyBase
	
var _target_position: Vector2 = Vector2.ZERO

func enter() -> void:
	character.play_animation("move")

func update(delta: float) -> void:
	# Обновляем цель
	if not target or not is_instance_valid(target):
		var idleState = ArcherIdleState.new()
		state_machine.change_state(idleState)
		return
	
	# Проверяем дистанцию
	var distance = character.global_position.distance_to(target.global_position)
	
	if distance <= character.stats.attack_range:
		var attackState = ArcherAttackState.new()
		attackState.target_enemy = target
		state_machine.change_state(attackState)
		return
	
	# Двигаемся к врагу
	_target_position = target.global_position
	_move_to_target()

func _move_to_target():
	character.velocity = character.global_position.direction_to(_target_position) * character.stats.speed
	character.move_and_slide()
	
	# Обновляем направление спрайта
	if character.velocity.x != 0:
		character.sprite_2d.scale.x = sign(character.velocity.x)
