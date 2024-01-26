extends Label


func _ready():
	Events.word_picked.connect(_on_word_picked)

func _on_word_picked(correct, joke_text):
	if correct: text = joke_text
