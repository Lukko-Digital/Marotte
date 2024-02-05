extends Control

@onready var transition : Transition = $StartTransition
var difficulty_select: PackedScene = preload("res://bullet_hell/levels/difficulty_select/difficulty_select.tscn")

func _ready():
	$NewGame.grab_focus()


func _on_new_game_mouse_entered():
	$NewGame.grab_focus()


func _on_quit_mouse_entered():
	$Quit.grab_focus()


func _on_new_game_pressed():
	transition.visible = true
	transition.play("end")
	await transition.transition_finished
	get_tree().change_scene_to_packed(difficulty_select)


func _on_quit_pressed():
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	$FadeAnimation.visible = false
