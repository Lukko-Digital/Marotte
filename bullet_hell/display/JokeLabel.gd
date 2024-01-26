extends Label


func _ready():
	Events.word_picked.connect(_on_word_picked)


func _on_word_picked(correct, joke_text):
	if correct: text = joke_text


func _on_bullet_hell_game_init_joke_text(joke_text):
	text = joke_text
