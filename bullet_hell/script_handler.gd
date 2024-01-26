extends Node2D

var game_script: PackedStringArray
var current_line: int = 0

enum Advance_Conditions {TIME, PICKUP, HIT}
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
		"!dialogue_words":
			spawn_dialogue_words.emit(split[1])
		"!joke_words":
			spawn_joke_words.emit(split[1])
		"!bullets":
			spawn_bullets.emit(split[1])
		"!transition":
			transition.play("start")
			await transition.transition_finished
			get_tree().change_scene_to_file("res://dialogue_scene/{dialogue}.tscn".format({"dialogue": split[1]}))
		"Player", "Jester":
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


func _on_timer_timeout():
	if advance_condition == Advance_Conditions.TIME:
		next_line()


func _on_word_picked(correct):
	if advance_condition == Advance_Conditions.PICKUP and correct:
		next_line()


func _on_bh_player_hit():
	if advance_condition == Advance_Conditions.HIT:
		next_line()
