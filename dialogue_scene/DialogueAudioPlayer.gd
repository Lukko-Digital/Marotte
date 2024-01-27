extends AudioStreamPlayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_sound(character: String):
	animation_player.play(character)
