extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer  # НОВЫЙ УЗЕЛ

func _ready():
	animation_player.play("default")

func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	var newX = int(mouse_position.x) - int(mouse_position.x) % 16 + 8
	var newY = int(mouse_position.y) - int(mouse_position.y) % 16 + 8
	self.position = Vector2i(newX, newY)
