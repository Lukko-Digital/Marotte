extends Area2D

func start(start_pos: Vector2, _dir):
	position = start_pos

func _on_body_entered(_body):
	Events.emit_signal("correct_word_picked")
	queue_free()
