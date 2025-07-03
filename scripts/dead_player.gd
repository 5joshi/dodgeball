extends RigidBody2D

@onready var player_radius: float = $CollisionShape2D.shape.radius * $CollisionShape2D.scale.x

func _ready() -> void:
	global_position = get_global_mouse_position()
	
	var screen_size = get_viewport_rect().size
	global_position.x = clamp(global_position.x, player_radius, screen_size.x - player_radius)
	global_position.y = clamp(global_position.y, player_radius, screen_size.y - player_radius)
