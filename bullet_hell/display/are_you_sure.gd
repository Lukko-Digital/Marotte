extends Control

signal dont_quit

func start():
	$Nope.grab_focus()
	visible = true


func _on_yes_mouse_entered():
	$Yes.grab_focus()


func _on_nope_mouse_entered():
	$Nope.grab_focus()


func _on_yes_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://bullet_hell/display/title_screne.tscn")


func _on_nope_pressed():
	visible = false
	dont_quit.emit()
