extends Sprite2D


func start(start_pos: Vector2, dir: Vector2):
	position = start_pos
	look_at(dir)


func _on_animation_player_animation_finished(anim_name):
	queue_free()
