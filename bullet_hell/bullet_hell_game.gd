extends Node2D

@onready var bullet_scene = preload("res://bullet_hell/bullet.tscn")
@onready var timer: Timer = $BulletTimer

const LEFT_X = 758
const RIGHT_X = 1625
const TOP_Y = 73
const BOTTOM_Y = 914

func _ready():
	timer.wait_time = 2

func _process(delta):
	pass

func random_from_left():
	var instance = bullet_scene.instantiate()
	instance.start(
		Vector2(LEFT_X, randi_range(TOP_Y, BOTTOM_Y)),
		Vector2(1, randf_range(0,1))
	)
	add_child(instance)

func _on_timer_timeout():
#	random_from_left()
	circle_from_left()

func circle_from_left():
	var num_shots = 12
	var angle = PI/num_shots
	var spawn_height = randi_range(TOP_Y, BOTTOM_Y)
	for i in range(num_shots):
		var instance = bullet_scene.instantiate()
		instance.start(
			Vector2(LEFT_X, spawn_height),
			Vector2(0, -1).rotated(angle*i)
		)
		add_child(instance)
