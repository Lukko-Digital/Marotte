extends AudioStreamPlayer
class_name DialogueAudioPlayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const PITCH_RANGES = {
	"Player" = [0.9, 1.1],
	"King" = [0.9, 1.1],
	"Jester" = [0.9, 1.1]
}

func play_sound(character: String):
	animation_player.stop(true)
	var pitch_range = PITCH_RANGES[character]
	pitch_scale = randf_range(pitch_range[0], pitch_range[1])
	animation_player.play(character)
