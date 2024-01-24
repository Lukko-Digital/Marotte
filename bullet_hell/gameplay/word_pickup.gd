extends Area2D

func _on_body_entered(body):
	Events.emit_signal("correct_word_picked")
	queue_free()
