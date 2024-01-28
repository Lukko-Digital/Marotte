extends Node

@export var with_intro: AudioStreamMP3
@export var without_intro: AudioStreamMP3
@export var volume: int
@onready var with_intro_player: AudioStreamPlayer = $WithIntro
@onready var without_intro_player: AudioStreamPlayer = $WithoutIntro

func _ready():
	with_intro_player.volume_db = volume
	without_intro_player.volume_db = volume
	with_intro_player.stream = with_intro
	without_intro_player.stream = without_intro
	with_intro_player.play()

func _on_with_intro_finished():
	without_intro_player.play()


func _on_without_intro_finished():
	without_intro_player.play()
