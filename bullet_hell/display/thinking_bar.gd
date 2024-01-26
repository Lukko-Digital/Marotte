extends ProgressBar

@onready var word_timer: Timer = get_parent()

func _process(delta):
	max_value = word_timer.wait_time
	value = word_timer.time_left
