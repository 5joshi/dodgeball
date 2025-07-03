extends Node

@export var enemy_scene: PackedScene
@export var dead_player_scene: PackedScene
var score := 0
var curr_balls := 0
var dead = false

func new_game():
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("dead_players", "queue_free")
	get_tree().call_group("enemies", "restore")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Player.show()
	
	dead = false
	score = 0
	curr_balls = 0
	$ScoreTimer.start()
	$SpawnTimer.start()
	$HUD.update_score(score)
	
	for i in range(3):
		spawn_enemy()
		
	$HUD.difficulty_update(curr_balls)
	$BackgroundMusic.play()

func game_over() -> void:
	if not dead:
		$DeathSound.play()
		get_tree().call_group("enemies", "fall")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		$HUD.game_over()
		$HUD.show_results(score)
		$ScoreTimer.stop()
		$SpawnTimer.stop()
		$BackgroundMusic.stop()
		$Player.hide()
		
		var dead_player = dead_player_scene.instantiate()
		call_deferred("add_child", dead_player)
		
		dead = true
	

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
	
func spawn_enemy():
	curr_balls += 1
	var enemy = enemy_scene.instantiate()
	enemy.initial_speed = 350 + 25 * curr_balls
	add_child(enemy)
	$HUD.difficulty_update(curr_balls)
