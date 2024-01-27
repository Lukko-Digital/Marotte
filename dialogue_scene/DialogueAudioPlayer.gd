extends AudioStreamPlayer
class_name DialogueAudioPlayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_sound(character: String):
	animation_player.play(character)
