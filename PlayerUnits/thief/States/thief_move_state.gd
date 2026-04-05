extends State
class_name ThiefMoveState

var target
var _path_calculation_cooldown: float
var _path_calculation_cooldown_max: float = 0.5

func _ready() -> void:
	_path_calculation_cooldown = _path_calculation_cooldown_max

func enter() -> void:
	character.play_animation("move")

func update(delta: float) -> void:
	if _path_calculation_cooldown > 0:
		_path_calculation_cooldown -= delta
	else:
		_make_path()

	# Обновляем цель
	if not target or not is_instance_valid(target):
		var idleState = ThiefIdleState.new()
		state_machine.change_state(idleState)
		return
	
	# Проверяем дистанцию
	var distance = character.global_position.distance_to(target.global_position)
	
	if distance <= character.stats.attack_range:
		var idleState = ThiefIdleState.new()
		state_machine.change_state(idleState)
		return
	
	# Двигаемся к цели
	_move_to_target()

func _move_to_target():
	var direction = character.to_local(character.navigation_agent.get_next_path_position()).normalized()
	character.velocity = direction * character.stats.speed
	character.move_and_slide()
	
	# Обновляем направление спрайта
	if character.velocity.x != 0:
		character.sprite_2d.scale.x = sign(character.velocity.x)

func _make_path() -> void:
	character.navigation_agent.target_position = target.global_position
	_path_calculation_cooldown = _path_calculation_cooldown_max
