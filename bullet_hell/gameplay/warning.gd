extends Sprite2D


## Expect args to contain one Vector2 which represents the direction
func start(start_pos: Vector2, args: Array):
	position = start_pos
	look_at(args[0])


func _on_animation_player_animation_finished(_anim_name):
	queue_free()
