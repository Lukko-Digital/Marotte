extends Control

@export var player_thought_bubble: CompressedTexture2D
@export var jester_thought_bubble: CompressedTexture2D
@export var jester_speech_bubble: CompressedTexture2D
@export var player_font: Font
@export var jester_font: Font
@export var jester_interface: CompressedTexture2D

@onready var health_bar: ProgressBar = $HealthBar
@onready var color_animation: AnimationPlayer = $ScreenColor/AnimationPlayer
@onready var player_image_animation: AnimationPlayer = $UIPlayer/AnimationPlayer
@onready var jester_image_animation: AnimationPlayer = $UIJester/AnimationPlayer
@onready var thought_bubble: TextureRect = $ThoughtBubble
@onready var jester_icon: Sprite2D = $ThoughtBubble/JesterIcon
@onready var dialogue_label: Label = $ThoughtBubble/Label
@onready var text_timer: Timer = $ThoughtBubble/Label/TextTimer
@onready var dialogue_audio: DialogueAudioPlayer = $ThoughtBubble/DialogueAudioPlayer
@onready var death_text_label: Label = $Death/DeathText

const MAX_HP = 2
var current_hp = MAX_HP : set = _set_current_hp
var jester_arena = false
var current_speaker

const TEXT_SPEED = 0.06

const DEATH_TEXT = [
	"you died of anxiety lmfao"
]

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
#	print(get_tree().current_scene.scene_file_path)
	if not jester_arena:
		if current_hp == 0:
			death()
			set_process(false)
		elif current_hp <= MAX_HP * 0.2:
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
	else:
		jester_image_animation.play("default")


func death():
	get_tree().paused = true
	
	$Death/DeathSound.play()
	$Death/DeathScreen.visible = true
	player_image_animation.play("death")
	$UIPlayer.z_index = 5
	
	death_text_label.text = DEATH_TEXT[0]
	print(death_text_label.text)
	death_text_label.visible_characters = 0
	death_text_label.visible = true
	
	while death_text_label.visible_characters < len(death_text_label.text):
		dialogue_audio.play_sound(current_speaker)
		death_text_label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
	
	await get_tree().create_timer(0.2).timeout
	$Death/TryAgain.visible = true
	await get_tree().create_timer(0.2).timeout
	$Death/GiveUp.visible = true

func _set_current_hp(new_hp):
	current_hp = clamp(new_hp, 0, MAX_HP)
	health_bar.value = current_hp


func _on_bullet_hell_game_use_jester_arena():
	$Interface.texture = jester_interface
	jester_arena = true
	$UIJester.visible = true
	$UIPlayer.visible = false


func _on_bh_player_hit():
	current_hp -= 1
	color_animation.play("red_flash")


func _on_word_picked(correct, _joke_text):
	if correct:
		current_hp += 2
		color_animation.play("big_white_flash")
	else:
		current_hp -= 2
		color_animation.play("red_flash")


func _on_word_timer_timeout():
	color_animation.play("white_flash")


func _on_script_handler_active_speaker(speaker):
	var split = speaker.split("_")
	current_speaker = split[0]
	if not jester_arena:
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
	else:
		thought_bubble.texture = jester_speech_bubble
		dialogue_label.size = Label_Size.PLAYER
		dialogue_label.position = Label_Position.PLAYER
		dialogue_label.set("theme_override_fonts/font", jester_font)
		jester_icon.visible = false


func _on_script_handler_display_line(text):
	dialogue_label.text = text
	dialogue_label.visible_characters = 0
	animate_display()


func animate_display():
	while dialogue_label.visible_characters < len(dialogue_label.text):
		dialogue_audio.play_sound(current_speaker)
		dialogue_label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
