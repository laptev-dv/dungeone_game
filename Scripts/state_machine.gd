extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State

func _ready():
	# Переход в начальное состояние
	if initial_state:
		change_state(initial_state)

func change_state(newState: State) -> void:
	if current_state:
		current_state.exit()
	
	newState.state_machine = self
	newState.character = get_parent()
	
	current_state = newState
	current_state.enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
