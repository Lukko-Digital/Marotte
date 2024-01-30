extends Control

@onready var transition : Transition = $StartTransition
var tutorial: PackedScene = preload("res://bullet_hell/levels/tutorial_level/tutorial_pre.tscn")

func _ready():
	$NewGame.grab_focus()


func _on_quit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	transition.visible = true
	transition.play("end")
	await transition.transition_finished
	get_tree().change_scene_to_packed(tutorial)


func _on_animation_player_animation_finished(anim_name):
	$FadeAnimation.visible = false
