extends Sprite3D

@onready var player : CharacterBody3D = get_parent().player

func _process(delta):
	look_at(player.position)
