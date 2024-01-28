extends Control

@onready var transition : Transition = $StartTransition

func _on_quit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	transition.visible = true
	transition.play("end")
	await transition.transition_finished
	get_tree().change_scene_to_file("res://bullet_hell/levels/tutorial_level/tutorial_pre.tscn")


func _on_animation_player_animation_finished(anim_name):
	$FadeAnimation.visible = false
