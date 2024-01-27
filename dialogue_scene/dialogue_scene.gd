extends CanvasLayer

@export var script_file_path: String
@onready var transition : Transition = $StartTransition
@onready var timer: Timer = $Timer

var active_label: Label
var display_in_progress = false

var game_script: PackedStringArray
var current_line: int = 0

enum Advance_Conditions {TIME, PICKUP, HIT, KEYPRESS}
var advance_condition: Advance_Conditions

#@onready var timer: Timer = $Timer

signal active_speaker(speaker)
signal display_line(text)
signal speed_animation
signal change_emotion(speaker, emotion)

func _ready():
	load_file()
	parse_line(game_script[0])

func _unhandled_key_input(event):
	if event.is_action_pressed("space") and advance_condition == Advance_Conditions.KEYPRESS:
		next_line()

func _on_timer_timeout():
	if advance_condition == Advance_Conditions.TIME:
		next_line()

func load_file():
	game_script = FileAccess.open(
		script_file_path,
		FileAccess.READ
	).get_as_text().strip_edges().split("\n")

func next_line():
	if display_in_progress:
		display_in_progress = false
		speed_animation.emit()
	else:
		current_line += 1
		if current_line >= len(game_script):
			return
		parse_line(game_script[current_line])


func parse_line(line: String):
	var split = line.split(": ")
	var command = split[0].split(" ")[0]
	match command:
		"!transition":
			transition.play("end")
			await transition.transition_finished
			get_tree().change_scene_to_file("res://bullet_hell/levels/{level}.tscn".format({"level": split[1]}))
		"!sound":
			var audio_player: AudioStreamPlayer = get_node(split[1])
			audio_player.play()
		"Player", "King", "Jester":
			active_speaker.emit(command)
			change_emotion.emit(command, split[0].split(" ")[1])
			display_line.emit(split[1])
			display_in_progress = true
			
		_:
			assert(false, "Error: Invalid tag in game script")
	
	match split[2]:
		"0":
			next_line()
		"keypress":
			advance_condition = Advance_Conditions.KEYPRESS
		_:
			if split[2].is_valid_float():
				timer.start(float(split[2]))
				advance_condition = Advance_Conditions.TIME
			else:
				assert(false, "Error: Invalid advance condition")


func _on_dialogue_box_text_animation_done():
	display_in_progress = false
