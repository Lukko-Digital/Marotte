extends TextureRect

@export var character_name : String
@export var dialogue_noise : AudioStreamPlayer

@onready var label : Label = $Label
@onready var text_timer : Timer = $TextTimer

signal text_animation_done

const TEXT_SPEED = 0.03

const VOICE_PITCH_MIN: float = 0.9
const VOICE_PITCH_MAX: float = 1.5

func _on_dialogue_scene_active_speaker(speaker):
	visible = speaker == character_name


func _on_dialogue_scene_display_line(text):
	if visible:
		label.text = text
		animate_display()

func animate_display():
	label.visible_characters = 0
	while label.visible_characters < len(label.text):
		dialogue_noise.pitch_scale = randf_range(VOICE_PITCH_MIN, VOICE_PITCH_MAX)
		dialogue_noise.play()
		label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
	text_animation_done.emit()


func _on_dialogue_scene_speed_animation():
	label.visible_characters = len(label.text)
