extends CanvasLayer

@export var script_file_path: String

@onready var player_box: TextureRect = $PlayerDialogueBox
@onready var player_label: Label = $PlayerDialogueBox/Label
@onready var king_box: TextureRect = $KingDialogueBox
@onready var king_label: Label = $KingDialogueBox/Label
@onready var text_timer: Timer = $TextTimer
@onready var dialogue_noise: AudioStreamPlayer = $DialogueAudioPlayer

var active_label: Label
var display_in_progress = false

const TEXT_SPEED = 0.03

const VOICE_PITCH_MIN: float = 0.9
const VOICE_PITCH_MAX: float = 1.5

var game_script: PackedStringArray
var current_line: int = 0
var advance_on_keypress: bool = true

#@onready var timer: Timer = $Timer

signal active_speaker(speaker)
signal display_line(text)
signal spawn_words(group)
signal spawn_bullets(pattern)

func _ready():
	load_file()
	parse_line(game_script[0])

func _unhandled_key_input(event):
	if event.is_action_pressed("space") and advance_on_keypress:
		next_line()

func load_file():
	game_script = FileAccess.open(
		script_file_path,
		FileAccess.READ
	).get_as_text().strip_edges().split("\n")

func animate_display():
	active_label.visible_characters = 0
	display_in_progress = true
	while active_label.visible_characters < len(active_label.text):
		dialogue_noise.pitch_scale = randf_range(VOICE_PITCH_MIN, VOICE_PITCH_MAX)
		dialogue_noise.play()
		active_label.visible_characters += 1
		text_timer.start()
		await text_timer.timeout
	display_in_progress = false
	

func next_line():
	current_line += 1
	if current_line >= len(game_script):
		return
	parse_line(game_script[current_line])


func parse_line(line: String):
	var split = line.split(": ")
	match split[0]:
		"Player", "King":
			active_speaker.emit(split[0])
			display_line.emit(split[1])
			
			var advance_condition = split[2]
			if advance_condition == "keypress":
#				timer.stop()
				advance_on_keypress = true
#			elif advance_condition.is_valid_int():
#				timer.start(int(advance_condition))
			else:
				assert(false, "Error: Invalid advance condition")
		_:
			assert(false, "Error: Invalid tag in game script")

#func advance_dialogue():
#	if display_in_progress:
#		# cut to the end of the line
#		active_label.visible_characters = len(active_label.text)
#	elif curr_dialogue_idx >= len(dialogue) - 1:
#		# end of dialogue
#		print("end")
#	else:
#		# next line
#		curr_dialogue_idx += 1
#		var line_split = dialogue[curr_dialogue_idx].split(": ")
#		match line_split[0]:
#			"Player":
#				player_box.visible = true
#				king_box.visible = false
#				active_label = player_box.get_node("Label")
#			"King":
#				king_box.visible = true
#				player_box.visible = false
#				active_label = king_box.get_node("Label")
#		active_label.text = line_split[1]
#		await animate_display()
