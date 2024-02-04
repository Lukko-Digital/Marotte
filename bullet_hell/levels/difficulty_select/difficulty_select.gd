extends Control

var tutorial: PackedScene = preload("res://bullet_hell/levels/tutorial_level/tutorial_pre.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		$Difficult.grab_focus()
	if event.is_action_pressed("ui_down"):
		$Normal.grab_focus()


func _on_normal_pressed():
	Difficulty.set_difficulty(Difficulty.Difficulties.NORMAL)
	get_tree().change_scene_to_packed(tutorial)


func _on_difficult_pressed():
	Difficulty.set_difficulty(Difficulty.Difficulties.HARD)
	get_tree().change_scene_to_packed(tutorial)
