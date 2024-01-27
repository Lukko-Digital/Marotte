extends Sprite2D

@export var character_name: String
@export var file_prefix: String

func _on_dialogue_scene_active_speaker(speaker):
	visible = speaker == character_name


func _on_dialogue_scene_change_emotion(speaker, emotion):
	if speaker == character_name:
		texture = load("res://assets/sprites/{prefix}_{emotion}.png".format({"prefix": file_prefix, "emotion": emotion}))

