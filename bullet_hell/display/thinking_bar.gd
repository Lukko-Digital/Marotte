extends ProgressBar

@onready var word_timer: Timer = get_parent()

func _process(delta):
	if word_timer.is_stopped():
		value = 0
	else:
		max_value = word_timer.wait_time
		value = word_timer.wait_time - word_timer.time_left
