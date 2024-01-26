extends Camera2D

var shake_amount

@onready var timer: Timer = $ShakeTimer
var default_offset: Vector2 = offset

func _ready():
	Events.word_picked.connect(_on_word_picked)

func _process(_delta):
	offset = default_offset
	handle_shake()

func _on_bh_player_hit():
	shake(0.2, 10)

func _on_word_picked(correct, _joke_text):
	if not correct:
		shake(0.2, 40)

func handle_shake():
	if not timer.is_stopped():
		var shake_offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)
		offset += shake_offset

func shake(duration: float, amount: float):
	timer.start(duration)
	shake_amount = amount
