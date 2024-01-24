extends Camera2D

const SHAKE_DURATION = 0.2
const SHAKE_AMOUNT = 10

@onready var timer: Timer = $ShakeTimer
var default_offset: Vector2 = offset

func _ready():
	pass # Replace with function body.

func _process(delta):
	offset = default_offset
	handle_shake()

func _on_bh_player_hit():
	timer.start(SHAKE_DURATION)

func handle_shake():
	if not timer.is_stopped():
		var shake_offset = Vector2(randf_range(-1, 1) * SHAKE_AMOUNT, randf_range(-1, 1) * SHAKE_AMOUNT)
		offset += shake_offset
