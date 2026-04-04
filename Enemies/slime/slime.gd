extends EnemyBase

func _ready():
	super._ready()
	# Слизь медленнее, но с большим здоровьем
	stats.speed = 50
	stats.max_health = 150
	current_health = stats.max_health

func special_jump_attack():
	# Эффект прыжка
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 50, 0.3)
	tween.tween_property(self, "position:y", position.y, 0.3)
