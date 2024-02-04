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
	
	warning_sound.play()
	spawn(warning_scene, spawn_position, [warning_dir])
	
	for i in range(num_cols):
		bullet_spawn_sound.play()
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


func spiral(spawn_position: Vector2, num_arms=2, num_shots=6, speed=0.5, rotate_dir=1, warning_time=0.5):
	spawn_position = spawn_position - position
	var warning_dir = spawn_position.rotated(PI)
	if warning_dir.is_zero_approx():
		warning_dir = Vector2(1,0)
	
	var shot_base_dir = spawn_position.rotated(PI)
	if shot_base_dir.is_zero_approx():
		shot_base_dir = Vector2(1,0)
	
	warning_sound.play()
	for i in range(num_arms):
		spawn(warning_scene, spawn_position, [warning_dir.rotated((2*PI/num_arms)*i)])
	
	await get_tree().create_timer(warning_time).timeout
	
	if shot_base_dir.is_zero_approx():
		shot_base_dir = Vector2(0,0)
	
	for j in range(num_shots):
		bullet_spawn_sound.play()
		for i in range(num_arms):
			spawn(
				bullet_scene,
				spawn_position,
				[shot_base_dir.rotated((2*PI/num_arms)*i + rotate_dir * (PI/8)*j), speed]
			)
		await get_tree().create_timer(0.2/speed).timeout


## Circle shot
func circle(spawn_position: Vector2, speed=1.0, num_shots=16, rotation=0):
	spawn_position = spawn_position - position
	var warning_dir = spawn_position.rotated(PI)
	var shot_base_dir = Vector2(1,0).rotated(rotation)
	
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
			
	circle(spawn_position, speed)


func circle_grid(speed=0.5, rounds=3):
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
			
	for i in range(rounds):
		var wait_time = (0.25/speed) * (1/Difficulty.bullet_speed_modifier)
		await get_tree().create_timer(wait_time).timeout
		circle(spawn_position, speed, 16, (PI/16) * i)


func zombies(speed=0.25):
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
			
	spawn_position = spawn_position - position
	var warning_dir = spawn_position.rotated(PI)
	
	warning_sound.play()
	spawn(warning_scene, spawn_position, [warning_dir])
	
	await get_tree().create_timer(0.5).timeout
	
	bullet_spawn_sound.play()
	spawn(zombie_scene, spawn_position, [player, speed, position])


func wall_pattern(pattern: String, direction: Vector2, speed=0.5):
	var instance = load("res://bullet_hell/gameplay/bullet_wall_pattern_%s.tscn" % pattern).instantiate()
	instance.start(direction, speed)
	add_child(instance)


func spawn_bullet_pattern():
	match active_bullet_mode:
		"circle":
			circle_pattern()
			set_spawn_timer(3)
		"double_circle":
			for i in range(2):
				circle_pattern()
			set_spawn_timer(3)
		"rapid_double_circle":
			for i in range(2):
				circle_pattern()
			set_spawn_timer(1.5)
		"slow_circle":
			circle_pattern(0.6)
			set_spawn_timer(3)
		"slow_double_circle":
			for i in range(2):
				circle_pattern(0.6)
			set_spawn_timer(3)
		"quick_circle":
			circle_pattern()
			set_spawn_timer(0.75)
		"fast_circle":
			circle_pattern(.9)
			set_spawn_timer(0.5)
		"spiral":
			spiral(game_center)
			set_spawn_timer(3)
		"spiral_warning":
			spiral(game_center, 3, 8, 0.5, 1, 1.5)
			set_spawn_timer(3.25)
		"final_spiral":
			spiral(game_center, 4, 8, 1)
			set_spawn_timer(3)
		"final_reverse_spiral":
			spiral(game_center, 4, 8, .8, -1)
			set_spawn_timer(3)
		"crazy_spiral":
			spiral(game_center, 5, 8, .5, -1)
			set_spawn_timer(3)
		"crazy_spiral_reverse":
			spiral(game_center, 5, 8, .5, -1)
			set_spawn_timer(3)
		"grid":
			horizontal_grid(Vector2(RIGHT_X, game_center.y))
			set_spawn_timer(1)
		"final_grid":
			horizontal_grid(Vector2(RIGHT_X, game_center.y), 5, 3, 0.8)
			set_spawn_timer(1)
		"wall_1":
			wall_pattern("1", Vector2(-1, 0), 1)
		"wall_2":
			wall_pattern("2", Vector2(-1, 0), .8)
		"wall_right":
			wall_pattern("right", Vector2(-1, 0), .8)
		"wall_left":
			wall_pattern("left", Vector2(-1, 0), .8)
		"wall_top":
			wall_pattern("top", Vector2(-1, 0), .8)
		"wall_bottom":
			wall_pattern("bottom", Vector2(-1, 0), .8)
		"wall_chicken_1":
			wall_pattern("chicken_1", Vector2(-1, 0), 0.6)
		"wall_chicken_1_slow":
			wall_pattern("chicken_1", Vector2(-1, 0), 0.25)
		"wall_chicken_2":
			wall_pattern("chicken_2", Vector2(-1, 0), 0.6)
		"wall_chicken_3":
			wall_pattern("chicken_3", Vector2(-1, 0), 0.6)
		"zombies":
			zombies()
			set_spawn_timer(1)
		"fast_zombies":
			zombies(0.35)
			set_spawn_timer(1)
		"circle_grid":
			circle_grid()
			set_spawn_timer(3)
		"final_circle_grid":
			circle_grid(1, 4)
			set_spawn_timer(2)
		"crazy_circle_grid":
			circle_grid(.8, 5)
			set_spawn_timer(2)

func set_spawn_timer(time: float):
	spawn_timer.wait_time = time * (1/Difficulty.bullet_speed_modifier)
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
			spawn(bullet_scene, Vector2(RIGHT_X - width/2, TOP_Y + 120) - position, [Vector2(), 0])
		_:
			active_bullet_mode = pattern
	spawn_bullet_pattern()


func _on_spawn_timer_timeout():
	spawn_bullet_pattern()
