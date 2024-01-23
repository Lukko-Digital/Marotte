extends CanvasLayer

@export var dialogue_label: Label
@export var text_timer: Timer

var dialogue: PackedStringArray
var curr_dialogue_idx = -1
var display_in_progress = false

const TEXT_SPEED = 0.03

func _ready():
	load_file()
	text_timer.wait_time = TEXT_SPEED

func _process(delta):
	if Input.is_action_just_pressed("space"):
		advance_dialogue()

func load_file():
	dialogue = FileAccess.open("res://dialogue_scene/test.txt", FileAccess.READ).get_as_text().strip_edges().split("\n")

func animate_display():
	dialogue_label.visible_characters = 0
	display_in_progress = true
	while dialogue_label.visible_characters < len(dialogue_label.text):
		dialogue_label.visible_characters += 1
		text_timer.start()
		await text_timer.timeout
	display_in_progress = false

func advance_dialogue():
	if display_in_progress:
		# cut to the end of the line
		dialogue_label.visible_characters = len(dialogue_label.text)
	elif curr_dialogue_idx >= len(dialogue):
		# end of dialogue
		print("end")
	else:
		# next line
		curr_dialogue_idx += 1
		dialogue_label.text = dialogue[curr_dialogue_idx]
		await animate_display()