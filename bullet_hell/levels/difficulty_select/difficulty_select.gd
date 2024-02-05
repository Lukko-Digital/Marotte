extends Control

@onready var transition : Transition = $StartTransition
var tutorial: PackedScene = preload("res://bullet_hell/levels/tutorial_level/tutorial_pre.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		$Difficult.grab_focus()
	if event.is_action_pressed("ui_down"):
		$Normal.grab_focus()


func _on_normal_pressed():
	Difficulty.set_difficulty(Difficulty.Difficulties.NORMAL)
	transition_to_tutorial()


func _on_difficult_pressed():
	Difficulty.set_difficulty(Difficulty.Difficulties.HARD)
	transition_to_tutorial()

func transition_to_tutorial():
	transition.visible = true
	transition.play("end")
	await transition.transition_finished
	get_tree().change_scene_to_packed(tutorial)
