extends Node2D

@export var player_units: Array[Dictionary] = [
	{"type": "knight", "count": 100, "stats": preload("res://Stats/Units/knight_stats.tres")},
	{"type": "archer", "count": 100, "stats": preload("res://Stats/Units/archer_stats.tres")},
	{"type": "thief", "count": 100, "stats": preload("res://Stats/Units/thief_stats.tres")},
]

@export var card_scene: PackedScene = preload("res://Scenes/UI/card_ui.tscn")

var active_card_index: int = 0
var player_units_count: Dictionary = {}

@onready var card_container: HBoxContainer = %CardContainer
@onready var game_world: Node2D = $GameWorld

func _ready():
	setup_cards()

func setup_cards():
	for i in range(player_units.size()):
		var card = card_scene.instantiate()
		card.setup(player_units[i]["type"], player_units[i]["count"])
		card.index = i
		card.card_selected.connect(_on_card_selected)
		card_container.add_child(card)
	
	# Выбираем первую карту активной
	if card_container.get_child_count() > 0:
		_on_card_selected(0)

func _on_card_selected(index: int):
	active_card_index = index
	# Визуально подсвечиваем активную карту
	for i in range(card_container.get_child_count()):
		var card = card_container.get_child(i)
		card.modulate = Color.YELLOW if i == index else Color.WHITE

func spawn_enemies():
	# Спавним несколько слизей для теста
	var slime_scene = preload("res://Enemies/slime/slime.tscn")
	var positions = [Vector2(500, 300), Vector2(700, 400), Vector2(600, 200)]
	
	for pos in positions:
		var slime = slime_scene.instantiate()
		slime.global_position = pos
		game_world.add_child(slime)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		spawn_player_unit(get_global_mouse_position())

func spawn_player_unit(position: Vector2):
	var selected_unit = player_units[active_card_index]
	
	if player_units_count.get(selected_unit["type"], 0) < selected_unit["count"]:
		var unit_scene = load("res://PlayerUnits/%s/%s.tscn" % [selected_unit["type"], selected_unit["type"]])
		var unit = unit_scene.instantiate()
		unit.stats = selected_unit["stats"]
		unit.global_position = position
		unit.add_to_group("units")
		game_world.add_child(unit)
		
		player_units_count[selected_unit["type"]] = player_units_count.get(selected_unit["type"], 0) + 1
		update_card_counter(selected_unit["type"])

func update_card_counter(unit_type: String):
	for card in card_container.get_children():
		if card.unit_type == unit_type:
			card.update_count(player_units_count[unit_type])


func _on_button_pressed():
	spawn_enemies()
