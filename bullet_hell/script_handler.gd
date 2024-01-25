extends Node2D

var game_script: PackedStringArray
var current_line: int = 0
var advance_on_pickup: bool = false

@onready var timer: Timer = $Timer

signal active_speaker(speaker)
signal display_line(text)
signal spawn_words(group)
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
		"!words":
			spawn_words.emit(split[1])
			next_line()
		"!bullets":
			spawn_bullets.emit(split[1])
			next_line()
		"Player", "Jester":
			active_speaker.emit(split[0])
			display_line.emit(split[1])
			
			var advance_condition = split[2]
			if advance_condition == "pickup":
				timer.stop()
				advance_on_pickup = true
			elif advance_condition.is_valid_int():
				timer.start(int(advance_condition))
			else:
				assert(false, "Error: Invalid advance condition")
		_:
			assert(false, "Error: Invalid tag in game script")


func _on_timer_timeout():
	next_line()


func _on_word_picked(correct):
	if correct and advance_on_pickup:
		next_line()
