extends CanvasLayer

@onready var player_box: TextureRect = $PlayerDialogueBox
@onready var player_label: Label = $PlayerDialogueBox/Label
@onready var king_box: TextureRect = $KingDialogueBox
@onready var king_label: Label = $KingDialogueBox/Label
@onready var text_timer: Timer = $TextTimer
@onready var dialogue_noise: AudioStreamPlayer = $DialogueAudioPlayer

var dialogue: PackedStringArray
var active_label: Label
var curr_dialogue_idx = -1
var display_in_progress = false

const TEXT_SPEED = 0.03

const VOICE_PITCH_MIN: float = 0.9
const VOICE_PITCH_MAX: float = 1.5

func _ready():
	load_file()
	text_timer.wait_time = TEXT_SPEED

func _process(delta):
	if Input.is_action_just_pressed("space"):
		advance_dialogue()

func load_file():
	dialogue = FileAccess.open("res://dialogue_scene/test.txt", FileAccess.READ).get_as_text().strip_edges().split("\n")

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

func advance_dialogue():
	if display_in_progress:
		# cut to the end of the line
		active_label.visible_characters = len(active_label.text)
	elif curr_dialogue_idx >= len(dialogue) - 1:
		# end of dialogue
		print("end")
	else:
		# next line
		curr_dialogue_idx += 1
		var line_split = dialogue[curr_dialogue_idx].split(": ")
		match line_split[0]:
			"Player":
				player_box.visible = true
				king_box.visible = false
				active_label = player_box.get_node("Label")
			"King":
				king_box.visible = true
				player_box.visible = false
				active_label = king_box.get_node("Label")
		active_label.text = line_split[1]
		await animate_display()
