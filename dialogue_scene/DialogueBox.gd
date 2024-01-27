extends TextureRect

@export var character_name : String
@export var dialogue_audio : DialogueAudioPlayer
@export var front_view : bool

@onready var label : Label = $Label
@onready var text_timer : Timer = $TextTimer

signal text_animation_done

const TEXT_SPEED = 0.08

var current_speaker

func _on_dialogue_scene_active_speaker(speaker):
	if not front_view:
		visible = speaker == character_name
	current_speaker = speaker

func _on_dialogue_scene_display_line(text):
	if visible:
		label.text = text
		animate_display()

func animate_display():
	label.visible_characters = 0
	while label.visible_characters < len(label.text):
		dialogue_audio.play_sound(current_speaker)
		label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
	text_animation_done.emit()


func _on_dialogue_scene_speed_animation():
	label.visible_characters = len(label.text)
