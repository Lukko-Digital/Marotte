extends Node2D

var game_script: PackedStringArray
var current_line: int = 0

@onready var timer: Timer = $Timer

signal active_speaker(speaker)
signal display_line(text)

func _ready():
	load_file()
	parse_line(game_script[0])


func _process(_delta):
	pass


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
			next_line()
		"!bullets":
			next_line()
		"Player", "Jester":
			active_speaker.emit(split[0])
			display_line.emit(split[1])
			timer.start(int(split[2]))
		_:
			assert(false, "Error: Invalid tag in game script")

func _on_timer_timeout():
	next_line()
