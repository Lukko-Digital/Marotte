extends Control
class_name Transition

signal transition_finished

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _on_animation_player_animation_finished(anim_name):
	transition_finished.emit()

func play():
	visible = true
	animation_player.play("clear")
