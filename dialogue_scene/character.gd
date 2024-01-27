extends AnimatedSprite2D

@export var character_name: String

func _on_dialogue_scene_active_speaker(speaker):
	visible = speaker == character_name


func _on_dialogue_scene_change_emotion(speaker, emotion):
	if speaker == character_name:
		play(emotion)
