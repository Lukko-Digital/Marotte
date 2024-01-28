extends Label

@export var jester_font: Font


func _ready():
	Events.word_picked.connect(_on_word_picked)


func _on_word_picked(correct, joke_text):
	if correct:
		if joke_text.left(1) == "#":
			modulate = Color(Color.WHITE, 0.3)
		else:
			text = joke_text


func _on_bullet_hell_game_init_joke_text(joke_text):
	if joke_text.left(1) == "!":
		add_theme_font_override("font", jester_font)
		text = joke_text.substr(1)
	else:
		text = joke_text
	if Checkpoint.white_joke_text:
		text = Checkpoint.white_joke_text
	if Checkpoint.red_joke_text:
		modulate = Color(Color.WHITE, 0.3)
