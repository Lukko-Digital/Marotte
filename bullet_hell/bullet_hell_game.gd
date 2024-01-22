extends Node2D

@onready var bullet_scene = preload("res://bullet_hell/bullet.tscn")
@onready var timer: Timer = $Timer

func _ready():
	timer.wait_time = 0.5

func _process(delta):
	pass

func spawn_bullet():
	var instance = bullet_scene.instantiate()
	instance.start(Vector2(0,0), Vector2(1,1))
	add_child(instance)

func _on_timer_timeout():
	spawn_bullet()
