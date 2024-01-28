extends AnimatedSprite2D

func _ready():
	play("default")

func _input(event):
	if event.is_action_pressed("space"):
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1,1,1,0), 1)
		tween.tween_callback(queue_free)
