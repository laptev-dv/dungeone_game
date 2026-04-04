extends Node
class_name State

# Ссылка на персонажа и state machine
var character: PlayerBase
var state_machine: StateMachine

# Вход в состояние
func enter() -> void:
	pass

# Выход из состояния
func exit() -> void:
	pass

# Обновление каждый кадр (physics_process)
func update(delta: float) -> void:
	pass

# Обработка ввода (input)
func handle_input(event: InputEvent) -> void:
	pass
