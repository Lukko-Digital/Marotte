extends Control


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = !visible
		get_tree().paused = !get_tree().paused
		$Resume.grab_focus()


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://bullet_hell/display/title_screne.tscn")


func _on_resume_pressed():
	visible = false
	get_tree().paused = false
