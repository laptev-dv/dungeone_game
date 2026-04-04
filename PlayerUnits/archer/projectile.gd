extends Area2D
class_name Projectile

@export var speed: float = 300.0
@export var damage: float = 10.0
@export var target: Node2D = null
@export var source: Node2D = null

var direction: Vector2 = Vector2.ZERO
var is_flying: bool = true

# Визуальные компоненты
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	# Настройка визуала (если нет спрайта, создаём простой круг)
	if not sprite_2d.texture:
		var image = Image.create(8, 8, false, Image.FORMAT_RGBA8)
		image.fill(Color.YELLOW)
		sprite_2d.texture = ImageTexture.create_from_image(image)
	
	# Настройка коллизии
	if not collision_shape.shape:
		var circle_shape = CircleShape2D.new()
		circle_shape.radius = 4.0
		collision_shape.shape = circle_shape
	
	# Подключаем сигнал столкновения
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	# Удаляем через 5 секунд, если не попал в цель
	await get_tree().create_timer(5.0).timeout
	if is_flying:
		queue_free()

func _physics_process(delta):
	if not is_flying:
		return
	
	# Если цели нет - удаляем снаряд
	if not target or not is_instance_valid(target):
		queue_free()
		return
	
	# Движемся к цели
	var new_direction = (target.global_position - global_position).normalized()
	direction = new_direction
	global_position += direction * speed * delta
	
	# Поворачиваем спрайт в сторону движения
	rotation = direction.angle()
	
	# Если подлетели близко к цели - наносим урон
	if global_position.distance_to(target.global_position) < 10.0:
		hit_target()

func hit_target() -> void:
	if not is_flying:
		return
	
	is_flying = false
	
	# Наносим урон цели
	if target and is_instance_valid(target):
		if target.has_method("take_damage"):
			target.take_damage(damage)
	
	# Удаляем снаряд
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	# Если столкнулись с врагом или игроком (но не с источником)
	if body == source:
		return
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == source:
		return
	
	if parent.has_method("take_damage"):
		parent.take_damage(damage)
		queue_free()
