extends TextureRect

@export var character_name : String
@onready var label : Label = $Label

func _on_dialogue_scene_active_speaker(speaker):
	visible = speaker == character_name


func _on_dialogue_scene_display_line(text):
	label.text = text
