extends Node2D

@export var script_file_path: String
@export var word_groups: JSON
@export var start_joke_text: String
@export var jester_arena: bool
@export var transition: Transition

@onready var bullet_scene = preload("res://bullet_hell/gameplay/bullet.tscn")
@onready var warning_scene = preload("res://bullet_hell/gameplay/warning.tscn")
@onready var word_scene = preload("res://bullet_hell/gameplay/word_pickup.tscn")
@onready var word_timer: Timer = $Environment/WordTimer
@onready var player: CharacterBody2D = $bh_player

## Sound Effects
@onready var word_spawn_sound: AudioStreamPlayer = $SoundEffects/WordSpawn
@onready var correct_word_sound: AudioStreamPlayer = $SoundEffects/CorrectWord
@onready var incorrect_word_sound: AudioStreamPlayer = $SoundEffects/IncorrectWord

signal init_joke_text(joke_text)
signal use_jester_arena

## Wall Locations
const LEFT_X = 758
const RIGHT_X = 1625
const TOP_Y = 73
const BOTTOM_Y = 892

## Spawn locations
const PLAYER_SPAWN = Vector2(1200, 500)
const WORD_SPAWN_X_OFFSET = 130
const WORD_SPAWN_Y_OFFSET = 80
const Word_Spawn = {
	TOP_LEFT = Vector2(LEFT_X + WORD_SPAWN_X_OFFSET, TOP_Y + WORD_SPAWN_Y_OFFSET),
	BOT_LEFT = Vector2(LEFT_X + WORD_SPAWN_X_OFFSET, BOTTOM_Y - WORD_SPAWN_Y_OFFSET),
	TOP_RIGHT = Vector2(RIGHT_X - WORD_SPAWN_X_OFFSET, TOP_Y + WORD_SPAWN_Y_OFFSET),
	BOT_RIGHT = Vector2(RIGHT_X - WORD_SPAWN_X_OFFSET, BOTTOM_Y - WORD_SPAWN_Y_OFFSET)
}

## Bullet Modes
#enum Bullet_Modes {NONE, CIRCLE, DOUBLE_CIRCLE}
var active_bullet_mode = "none"
signal spawn_bullet_pattern(mode: String, args: Array)

## Direction enum
const Direction = {
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0),
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1)
}

func _ready():
	transition.play("start")
	player.position = PLAYER_SPAWN
	Events.word_picked.connect(_on_word_picked)
	init_joke_text.emit(start_joke_text)
	if jester_arena: use_jester_arena.emit()


## Reset upon word pickup
func _on_word_picked(correct, _joke_text):
	if correct:
		correct_word_sound.play()
		get_tree().call_group("bullet", "queue_free")
		get_tree().call_group("word", "queue_free")
		player.position = PLAYER_SPAWN
#		word_timer.start()
	else:
		incorrect_word_sound.play()


## Spawn external scene, used for bullets, warnings, and words
func spawn(scene: PackedScene, spawn_position: Vector2, args: Array):
	var instance = scene.instantiate()
	instance.start(spawn_position, args)
	add_child(instance)


## ============================== Words ==============================


## Word Timer
func _on_word_timer_timeout():
	pass


## When the script handler says to spawn dialogue words
func _on_script_handler_spawn_dialogue_words(group):
	await get_tree().create_timer(2).timeout
	spawn_words(group)


## When the script handler says to spawn joke words
func _on_script_handler_spawn_joke_words(group):
	word_timer.start(3)
	await get_tree().create_timer(3).timeout
	spawn_words(group)


## Spawn words in the four corners, with one being incorrect
func spawn_words(group):
	word_spawn_sound.play()
	var word_map: Dictionary = word_groups.data[group]
	var joke_text = word_map["!joke_text"]
	word_map.erase("!joke_text")
	
	var spawn_locations = Word_Spawn.values()
	spawn_locations.shuffle()
	
	for word in word_map:
		var correct = word_map[word]
		spawn(
			word_scene,
			spawn_locations.pop_back(),
			[
				correct,
				word,
				joke_text if correct else null
			]
		)
