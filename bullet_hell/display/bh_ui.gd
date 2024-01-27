extends Control

@export var player_thought_bubble: CompressedTexture2D
@export var jester_thought_bubble: CompressedTexture2D
@export var player_font: Font
@export var jester_font: Font

@onready var health_bar: ProgressBar = $HealthBar
@onready var color_animation: AnimationPlayer = $ScreenColor/AnimationPlayer
@onready var player_image_animation: AnimationPlayer = $UIPlayer/AnimationPlayer
@onready var thought_bubble: TextureRect = $ThoughtBubble
@onready var jester_icon: Sprite2D = $ThoughtBubble/JesterIcon
@onready var dialogue_label: Label = $ThoughtBubble/Label
@onready var text_timer: Timer = $ThoughtBubble/Label/TextTimer
@onready var dialogue_noise: AudioStreamPlayer = $ThoughtBubble/DialogueAudioPlayer

const MAX_HP = 10
var current_hp = MAX_HP : set = _set_current_hp

const TEXT_SPEED = 0.03

const Label_Size = {
	PLAYER = Vector2(2335, 835),
	JESTER = Vector2(1705, 835)
	
}

const Label_Position = {
	PLAYER = Vector2(235, 175),
	JESTER = Vector2(925, 175)
}

enum Jester_Icon_Frames { NEUTRAL, ANGRY, HAPPY }

const VOICE_PITCH_MIN = 0.9
const VOICE_PITCH_MAX = 1.5

func _ready():
	Events.word_picked.connect(_on_word_picked)
	health_bar.max_value = MAX_HP
	health_bar.value = MAX_HP

func _process(_delta):
	if current_hp <= MAX_HP * 0.2:
		player_image_animation.play("stress3")
		color_animation.speed_scale = 2
		color_animation.play("pulse")
	elif current_hp <= MAX_HP * 0.5:
		player_image_animation.play("stress2")
		color_animation.play("pulse")
	elif current_hp <= MAX_HP * 0.7:
		player_image_animation.play("stress1")
	else:
		player_image_animation.play("stress0")


func _set_current_hp(new_hp):
	current_hp = clamp(new_hp, 0, MAX_HP)
	health_bar.value = current_hp


func _on_bh_player_hit():
	current_hp -= 1
	color_animation.play("red_flash")


func _on_word_picked(correct, _joke_text):
	if correct:
		current_hp += 2
		color_animation.play("white_flash")
	else:
		current_hp -= 2
		color_animation.play("red_flash")


func _on_word_timer_timeout():
	color_animation.play("white_flash")


func _on_script_handler_active_speaker(speaker):
	var split = speaker.split("_")
	match split[0]:
		"Player":
			thought_bubble.texture = player_thought_bubble
			dialogue_label.size = Label_Size.PLAYER
			dialogue_label.position = Label_Position.PLAYER
			dialogue_label.set("theme_override_fonts/font", player_font)
			jester_icon.visible = false
		"Jester":
			thought_bubble.texture = jester_thought_bubble
			dialogue_label.size = Label_Size.JESTER
			dialogue_label.position = Label_Position.JESTER
			dialogue_label.set("theme_override_fonts/font", jester_font)
			jester_icon.visible = true
			match split[1]:
				"neutral":
					jester_icon.frame = Jester_Icon_Frames.NEUTRAL
				"angry":
					jester_icon.frame = Jester_Icon_Frames.ANGRY
				"happy":
					jester_icon.frame = Jester_Icon_Frames.HAPPY


func _on_script_handler_display_line(text):
	dialogue_label.text = text
	dialogue_label.visible_characters = 0
	animate_display()

func animate_display():
	while dialogue_label.visible_characters < len(dialogue_label.text):
		dialogue_noise.pitch_scale = randf_range(VOICE_PITCH_MIN, VOICE_PITCH_MAX)
		dialogue_noise.play()
		dialogue_label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
