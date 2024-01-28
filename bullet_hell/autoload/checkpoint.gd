extends Node

var reload_point: int = 0
var white_joke_text: String
var red_joke_text: String

func _ready():
	Events.word_picked.connect(_on_word_picked)

func _on_word_picked(correct, joke_text):
	if correct:
		if joke_text.left(1) == "#":
			red_joke_text = joke_text.substr(1)
		else:
			white_joke_text = joke_text
