extends Node2D

@export var bullet_spawn_sound: AudioStreamPlayer
@export var warning_sound: AudioStreamPlayer
@export var player: CharacterBody2D

@onready var bullet_scene = preload("res://bullet_hell/gameplay/bullet.tscn")
@onready var warning_scene = preload("res://bullet_hell/gameplay/warning.tscn")
@onready var zombie_scene = preload("res://bullet_hell/gameplay/zombie_bullet.tscn")
@onready var spawn_timer : Timer = $SpawnTimer

const LEFT_X = 758
const RIGHT_X = 1625
const TOP_Y = 73
const BOTTOM_Y = 892

var width = RIGHT_X-LEFT_X
var height = BOTTOM_Y-TOP_Y

var game_center = Vector2(LEFT_X + width/2, TOP_Y + height/2)

## Direction enum
const Direction = {
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0),
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1)
}

var active_bullet_mode: String

func spawn(scene: PackedScene, spawn_position: Vector2, args: Array):
	var instance = scene.instantiate()
	instance.start(spawn_position, args)
	add_child(instance)


func horizontal_grid(spawn_position: Vector2, num_rows=3, num_cols=2, speed=0.5):
	spawn_position = spawn_position - position
	var warning_dir = spawn_position.rotated(PI)
	if warning_dir.is_zero_approx():
		warning_dir = Vector2(0,1)
	
	var shot_base_dir = spawn_position.rotated(PI).normalized()
	if shot_base_dir.is_zero_approx():
		shot_base_dir = Vector2(0,1)
		
	await get_tree().create_timer(0.5).timeout
	
	spawn(warning_scene, spawn_position, [warning_dir])
	
	for i in range(num_cols):
		for j in range(num_rows):
			spawn(
				bullet_scene,
				spawn_position
					+ Vector2(0,1) * height/num_rows * (j+0.5) 
					- Vector2(0, height/2) 
					+ Vector2(0,1) * height/num_rows/2 * (i%2 - 0.5),
				[shot_base_dir, speed]
			)
		
		await get_tree().create_timer(0.25/speed).timeout


func vertical_grid(spawn_position: Vector2, num_rows=2, num_cols=3, speed=0.5):
	spawn_position = spawn_position - position
	var warning_dir = spawn_position.rotated(PI)
	if warning_dir.is_zero_approx():
		warning_dir = Vector2(1,0)
	
	var shot_base_dir = spawn_position.rotated(PI).normalized()
	if shot_base_dir.is_zero_approx():
		shot_base_dir = Vector2(1,0)
		
	await get_tree().create_timer(0.5).timeout
	
	spawn(warning_scene, spawn_position, [warning_dir])
	
	for i in range(num_cols):
		for j in range(num_rows):
			spawn(
				bullet_scene,
				spawn_position
					+ Vector2(1,0) * width/num_cols * (j+0.5) 
					- Vector2(width/2,0) 
					+ Vector2(1,0) * width/num_cols/2 * (i%2 - 0.5),
				[shot_base_dir, speed]
			)
		
		await get_tree().create_timer(0.25/speed).timeout


func spiral(spawn_position: Vector2, num_arms=2, num_shots=6, speed=0.5):
	spawn_position = spawn_position - position
	var warning_dir = spawn_position.rotated(PI)
	if warning_dir.is_zero_approx():
		warning_dir = Vector2(1,0)
	
	var shot_base_dir = spawn_position.rotated(PI)
	if shot_base_dir.is_zero_approx():
		shot_base_dir = Vector2(1,0)
	
	for i in range(num_arms):
		spawn(warning_scene, spawn_position, [warning_dir.rotated((2*PI/num_arms)*i)])
	
	await get_tree().create_timer(0.5).timeout
	
	if shot_base_dir.is_zero_approx():
		shot_base_dir = Vector2(0,0)
	
	for j in range(num_shots):
		for i in range(num_arms):
			spawn(
				bullet_scene,
				spawn_position,
				[shot_base_dir.rotated((2*PI/num_arms)*i + (PI/8)*j), speed]
			)
		await get_tree().create_timer(0.2/speed).timeout


## Circle shot
func circle(spawn_position: Vector2, speed=1.0, num_shots=16):
	spawn_position = spawn_position - position
	var warning_dir = spawn_position.rotated(PI)
	var shot_base_dir = Vector2(1,0)#spawn_position.rotated(PI/2)
	
	spawn(warning_scene, spawn_position, [warning_dir])
	warning_sound.play()
	await get_tree().create_timer(0.5).timeout
	bullet_spawn_sound.play()
	for i in range(num_shots):
		spawn(
			bullet_scene,
			spawn_position,
			[shot_base_dir.rotated(2*PI/num_shots*i), speed]
		)


func circle_pattern(speed=1.0):
	var direction = Direction.values().pick_random()
	var spawn_position: Vector2
	match direction:
		Direction.LEFT:
			spawn_position = Vector2(LEFT_X, randi_range(TOP_Y, BOTTOM_Y))
		Direction.RIGHT:
			spawn_position = Vector2(RIGHT_X, randi_range(TOP_Y, BOTTOM_Y))
		Direction.UP:
			spawn_position = Vector2(randi_range(LEFT_X, RIGHT_X), TOP_Y)
		Direction.DOWN:
			spawn_position = Vector2(randi_range(LEFT_X, RIGHT_X), BOTTOM_Y)
			
	circle(spawn_position-position, speed)


func zombies(speed=0.5):
	var direction = Direction.values().pick_random()
	var spawn_position: Vector2
	match direction:
		Direction.LEFT:
			spawn_position = Vector2(LEFT_X, randi_range(TOP_Y, BOTTOM_Y))
		Direction.RIGHT:
			spawn_position = Vector2(RIGHT_X, randi_range(TOP_Y, BOTTOM_Y))
		Direction.UP:
			spawn_position = Vector2(randi_range(LEFT_X, RIGHT_X), TOP_Y)
		Direction.DOWN:
			spawn_position = Vector2(randi_range(LEFT_X, RIGHT_X), BOTTOM_Y)
			
	spawn(zombie_scene, spawn_position, [player, speed, position])


func wall_pattern(number: int, direction: Vector2, speed=0.5):
	var instance = load("res://bullet_hell/gameplay/bullet_wall_pattern_%d.tscn" % number).instantiate()
	instance.start(direction, speed)
	add_child(instance)


func spawn_bullet_pattern():
	match active_bullet_mode:
		"circle":
			circle_pattern()
			spawn_timer.wait_time = 3
			spawn_timer.start()
		"double_circle":
			for i in range(2):
				circle_pattern()
			spawn_timer.wait_time = 3
			spawn_timer.start()
		"slow_circle":
			circle_pattern(0.6)
			spawn_timer.wait_time = 3
			spawn_timer.start()
		"slow_double_circle":
			for i in range(2):
				circle_pattern(0.6)
			spawn_timer.wait_time = 3
			spawn_timer.start()
		"fast_circle":
			circle_pattern(1.5)
			spawn_timer.wait_time = 0.5
			spawn_timer.start()
		"spiral":
			spiral(game_center)
			spawn_timer.wait_time = 3
			spawn_timer.start()
		"grid":
			horizontal_grid(Vector2(RIGHT_X, game_center.y))
			spawn_timer.wait_time = 1
			spawn_timer.start()
		"wall_1":
			wall_pattern(1, Vector2(-1, 0))
		"zombies":
			zombies()
			spawn_timer.wait_time = 1
			spawn_timer.start()


func _on_script_handler_spawn_bullets(pattern):
	match pattern:
		"none":
			active_bullet_mode = "none"
			spawn_timer.stop()
		"still":
			active_bullet_mode = "none"
			spawn_timer.stop()
			## Very specific only used in the tutorial
			await get_tree().create_timer(1).timeout
			spawn(bullet_scene, Vector2(RIGHT_X - 130, TOP_Y + 80) - position, [Vector2(), 0])
		_:
			active_bullet_mode = pattern
	spawn_bullet_pattern()


func _on_spawn_timer_timeout():
	spawn_bullet_pattern()
