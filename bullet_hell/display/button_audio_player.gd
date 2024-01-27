extends AnimationPlayer



func _on_mouse_entered():
	play("hover")


func _on_pressed():
	play("click")
