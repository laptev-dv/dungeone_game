extends Panel
class_name CardUI

signal card_selected(index: int)

@export var unit_name_label: Label
@export var count_label: Label
@export var texture_rect: TextureRect

var unit_type: String
var max_count: int
var current_count: int = 0
var index: int = 0

func setup(type: String, count: int):
	unit_type = type
	max_count = count
	unit_name_label.text = type.capitalize()
	update_count(0)

func update_count(new_count: int):
	current_count = new_count
	count_label.text = "%d" % [max_count - current_count]
	modulate = Color.GRAY if current_count >= max_count else modulate

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_count < max_count:
			card_selected.emit(index)
