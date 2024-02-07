extends Node2D

var path : String

var game_script: PackedStringArray
var current_line: int = 0

enum Advance_Conditions {TIME, PICKUP, HIT, KEYPRESS}
var advance_condition: Advance_Conditions

@onready var timer: Timer = $Timer
@onready var transition : Transition = $ClearTransition

signal active_speaker(speaker)
signal display_line(text)
signal spawn_dialogue_words(group)
signal spawn_joke_words(group)
signal spawn_bullets(pattern)

func _ready():
	load_file()
	parse_line(game_script[0])
	Events.word_picked.connect(_on_word_picked)
	current_line = Checkpoint.reload_point


func load_file():
	game_script = FileAccess.open(
		get_parent().script_file_path,
		FileAccess.READ
	).get_as_text().strip_edges().split("\n")


func next_line():
	current_line += 1
	if current_line >= len(game_script):
		return
	parse_line(game_script[current_line])


func parse_line(line: String):
	var split = line.split(": ")
	match split[0]:
		"!nextscene":
			path = "res://bullet_hell/levels/{level}.tscn".format({"level": split[1]})
			ResourceLoader.load_threaded_request(path)
		"!dialogue_words":
			spawn_dialogue_words.emit(split[1])
		"!joke_words":
			spawn_joke_words.emit(split[1])
		"!bullets":
			spawn_bullets.emit(split[1])
		"!checkpoint":
			Checkpoint.reload_point = current_line
			next_line()
			return
		"!transition":
			Checkpoint.reload_point = 0
			transition.play("clear")
			transition_to()
		"!final_transition":
			transition.play("black")
			transition_to()
		"Player", "Jester_neutral", "Jester_angry", "Jester_happy", "Jester_chicken":
			active_speaker.emit(split[0])
			display_line.emit(split[1])
		_:
			assert(false, "Error: Invalid tag in game script")

	match split[2]:
		"0":
			next_line()
		"pickup":
			advance_condition = Advance_Conditions.PICKUP
		"hit":
			advance_condition = Advance_Conditions.HIT
		_:
			if split[2].is_valid_float():
				timer.start(float(split[2]))
				advance_condition = Advance_Conditions.TIME
			else:
				assert(false, "Error: Invalid advance condition")


func transition_to():
	Checkpoint.reload_point = 0
	Events.level_complete.emit()
	await transition.transition_finished
	var packed_scene := ResourceLoader.load_threaded_get(path) as PackedScene
	get_tree().change_scene_to_packed(packed_scene)

func _on_timer_timeout():
	if advance_condition == Advance_Conditions.TIME:
		next_line()


func _on_word_picked(correct, _joke_text):
	if advance_condition == Advance_Conditions.PICKUP and correct:
		next_line()


func _on_bh_player_hit():
	if advance_condition == Advance_Conditions.HIT:
		next_line()
