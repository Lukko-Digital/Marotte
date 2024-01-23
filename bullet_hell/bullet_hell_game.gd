extends Node2D

@onready var bullet_scene = preload("res://bullet_hell/bullet.tscn")
@onready var timer: Timer = $BulletTimer

func _ready():
	timer.wait_time = 0.1

func _process(delta):
	pass

func spawn_bullet():
	var instance = bullet_scene.instantiate()
	instance.start(
		Vector2(758, randi_range(73, 914)),
		Vector2(1, randf_range(-1,1))
	)
	add_child(instance)

func _on_timer_timeout():
	spawn_bullet()
