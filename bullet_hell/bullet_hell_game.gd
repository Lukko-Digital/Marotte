extends Node2D

@onready var bullet_scene = preload("res://bullet_hell/bullet.tscn")
@onready var warning_scene = preload("res://bullet_hell/warning.tscn")
@onready var timer: Timer = $BulletTimer

const LEFT_X = 758
const RIGHT_X = 1625
const TOP_Y = 73
const BOTTOM_Y = 914

const Direction = {
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0),
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1)
}

func _ready():
	timer.wait_time = 2

func _process(delta):
	pass

func _on_timer_timeout():
	circle(Direction.values().pick_random(), 8)
	circle(Direction.values().pick_random(), 8)

func circle(direction: Vector2, num_shots=12):
	var spawn_position: Vector2
	var warning_dir = direction.rotated(PI)
	var shot_base_dir = direction.rotated(PI/2)
	
	match direction:
		Direction.LEFT:
			spawn_position = Vector2(LEFT_X, randi_range(TOP_Y, BOTTOM_Y))
		Direction.RIGHT:
			spawn_position = Vector2(RIGHT_X, randi_range(TOP_Y, BOTTOM_Y))
		Direction.UP:
			spawn_position = Vector2(randi_range(LEFT_X, RIGHT_X), TOP_Y)
		Direction.DOWN:
			spawn_position = Vector2(randi_range(LEFT_X, RIGHT_X), BOTTOM_Y)
	
	spawn(warning_scene, spawn_position, warning_dir)
	await get_tree().create_timer(0.5).timeout
	for i in range(num_shots):
		spawn(
			bullet_scene,
			spawn_position,
			shot_base_dir.rotated(PI/num_shots*i)
		)

func random_from_left():
	var instance = bullet_scene.instantiate()
	instance.start(
		Vector2(LEFT_X, randi_range(TOP_Y, BOTTOM_Y)),
		Vector2(1, randf_range(0,1))
	)
	add_child(instance)

func spawn(scene: PackedScene, position: Vector2, direction: Vector2):
	var instance = scene.instantiate()
	instance.start(position, direction)
	add_child(instance)
