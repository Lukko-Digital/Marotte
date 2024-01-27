extends Control

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = !visible
		get_tree().paused = !get_tree().paused
		


func _on_quit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	visible = false
	get_tree().paused = false
