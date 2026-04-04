extends PlayerBase

func _ready():
	super._ready()
	# Можно добавить специфичные для рыцаря механики
	# Например, дополнительная броня

func special_ability():
	# Временная неуязвимость
	modulate = Color(0.5, 0.5, 1)
	await get_tree().create_timer(2.0).timeout
	modulate = Color.WHITE
