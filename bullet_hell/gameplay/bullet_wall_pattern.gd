extends Node2D

func start(direction: Vector2, speed):
	for bullet in get_children():
		bullet.start(bullet.position, [direction, speed])
