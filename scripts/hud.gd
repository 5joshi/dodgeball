extends CanvasLayer

signal start_game

@export var message_fade_duration := 0.5
@export var result_threshold := 15
var difficulty_messages = [
	"Easy Peasy",
	"Still Quite Easy",
	"Fun Begins Now",
	"Quite Challenging", 
	"Pretty Tough",
	"Very Tricky",
	"Terribly Hard",
	"Insanely Difficult",
	"Totally Nuts",
	"Incredibly Challenging",
	"Almost Impossible",
	"Utterly Incredible",
	"Totally Impossible"
]
var results = ["F", "E", "D", "C", "B", "A", "A+", "S"]
var results_messages = {
	"F": ["You are worthless", "Get a life", "Are you disabled?"],
	"E": ["Are you even trying?", "My mom would've beat you", "You suck balls"],
	"D": ["Please do better", "Did you have to sneeze?", "Was your little sister playing?"],
	"C": ["Not great", "Better luck next time", "Surely you can do better"],
	"B": ["Pretty alright", "Nice I guess...", "Decent..."],
	"A": ["Woah you're pretty good", "Nice one!!!", "Let's freaking go!"],
	"A+": ["God gamer!", "You're an absolute prodigy!", "OwO"],
	"S": ["Have my babies", "Truly unmatched", "You're the man!"],
}

func flash_message(text):
	$Message.modulate = Color(1, 1, 1, 0)
	show_message(text)
	
	var message_tween_in = create_tween()
	message_tween_in.set_ease(Tween.EASE_IN)
	message_tween_in.set_trans(Tween.TRANS_QUAD)
	message_tween_in.tween_property($Message, "modulate:a", 1.0, message_fade_duration)
	
	await $MessageTimer.timeout
	# if $Message.text != text: return
	
	# var message_tween_out = create_tween()
	# message_tween_out.set_ease(Tween.EASE_OUT)
	# message_tween_out.set_trans(Tween.TRANS_QUAD)
	# message_tween_out.tween_property($Message, "modulate:a", 0.0, message_fade_duration)
	clear_message()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func clear_message():
	$Message.text = ""
	$Message.hide()
	
func game_over():
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	
	$StartButton.show()
	
func difficulty_update(balls):
	var text = str(balls) + " Balls\n"
	if balls <= 15:
		text += difficulty_messages[balls - 3]
	else:
		text += difficulty_messages[-1]
		
	flash_message(text)

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	clear_message()
	$StartButton.hide()
	start_game.emit()
	
func show_results(score):
	var idx = floor(score / result_threshold)
	if idx >= results.size(): idx = results.size() - 1

	var message = "Grade " + results[idx] + ":\n" + results_messages[results[idx]].pick_random()
	print(message)
	show_message(message)
	
