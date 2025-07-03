extends RigidBody2D

@export var initial_speed = 400.0
var impulse_magnitude := 0.0
var sprites = [load("res://sprites/meanball1.png"), load("res://sprites/meanball2.png"), load("res://sprites/meanball3.png")]

func _ready():
	var screen_size = get_viewport_rect().size
	global_position = Vector2(randf_range(50, screen_size.x - 50), randf_range(50, screen_size.y - 50))
	
	randomize()
	$Sprite2D.texture = sprites[randi() % sprites.size()]
	$Sprite2D.modulate = Color(1, 1, 1, 0)
	
	var enemy_tween = create_tween()
	enemy_tween.set_ease(Tween.EASE_IN)
	enemy_tween.set_trans(Tween.TRANS_QUAD)
	enemy_tween.tween_property($Sprite2D, "modulate:a", 1.0, 2)
	
	$CollisionShape2D.disabled = true
	await enemy_tween.finished
	$CollisionShape2D.disabled = false
	
	sleeping = false
	can_sleep = false
	
	launch()
	
func launch():
	var random_angle = randf_range(0, PI * 2)
	linear_velocity = Vector2(cos(random_angle), sin(random_angle)) * initial_speed
	
func fall():
	gravity_scale = 1.0
	physics_material_override.bounce = 0.6
	physics_material_override.friction = 0.5
	
func restore():
	gravity_scale = 0.0
	physics_material_override.bounce = 1.0
	physics_material_override.friction = 0.0

func _on_body_entered(body: Node) -> void:
	var normalized_impulse = remap(linear_velocity.length(), 300, 1200, 0, 1)
	var volume = lerp(-30, 0, normalized_impulse)
	
	if body is RigidBody2D:
		$BallSound.volume_db = volume
		$BallSound.play()
	elif body is StaticBody2D:
		$WallSound.volume_db = volume
		$WallSound.play()
