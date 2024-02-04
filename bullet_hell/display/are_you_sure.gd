extends Control


func start():
	$Nope.grab_focus()
	visible = true


func _on_yes_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://bullet_hell/display/title_screne.tscn")


func _on_nope_pressed():
	visible = false
