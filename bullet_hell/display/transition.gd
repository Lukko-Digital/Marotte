extends Control
class_name Transition

signal transition_finished

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.connect("animation_finished", _on_animation_player_animation_finished)

func _on_animation_player_animation_finished(anim_name):
	transition_finished.emit()

func play(anim_name: String):
	if !animation_player:
		await ready
	animation_player.play(anim_name)
	visible = true
