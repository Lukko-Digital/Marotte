extends Label


func _ready():
	Events.word_picked.connect(_on_word_picked)

func _on_word_picked(correct, joke_text):
	if correct and joke_text.left(1) == "#":
		visible = true
		text = joke_text.substr(1)
