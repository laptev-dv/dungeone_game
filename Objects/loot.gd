extends Node
class_name Loot

var current_health: float = 40

func _ready():
	# Добавляем в группу для обнаружения лута
	add_to_group("loot")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loot(amount: float):
	current_health -= amount	
	if current_health <= 0:
		die()

func die():
	queue_free()
