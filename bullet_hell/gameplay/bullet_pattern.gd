extends Node2D

@onready var bullet_scene = preload("res://bullet_hell/gameplay/bullet.tscn")
@onready var warning_scene = preload("res://bullet_hell/gameplay/warning.tscn")

func _ready():
	await get_tree().create_timer(0.5).timeout
	
	horizontal_grid(Vector2(0,540), 5, 10, 1)
	vertical_grid(Vector2(960, 0), 10, 7, 1)

func horizontal_grid(spawn_position: Vector2, num_rows=5, num_cols=5, speed=1):
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
					+ Vector2(0,1) * 1080/num_rows * (j+0.5) 
					- Vector2(0, 1080/2) 
					+ Vector2(0,1) * 1080/num_rows/2 * (i%2 - 0.5),
				[shot_base_dir, 250*speed]
			)
		
		await get_tree().create_timer(0.5/speed).timeout


func vertical_grid(spawn_position: Vector2, num_rows=5, num_cols=5, speed=1):
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
					+ Vector2(1,0) * 1920/num_cols * (j+0.5) 
					- Vector2(1920/2,0) 
					+ Vector2(1,0) * 1920/num_cols/2 * (i%2 - 0.5),
				[shot_base_dir, 250*speed]
			)
		
		await get_tree().create_timer(0.5/speed).timeout

func spiral(spawn_position: Vector2, num_arms=2, num_shots=12, speed=1):
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
				[shot_base_dir.rotated((2*PI/num_arms)*i + (PI/8)*j), 250*speed]
			)
		await get_tree().create_timer(0.2/speed).timeout


## Circle shot
func circle(spawn_position: Vector2, num_shots=24):
	spawn_position = spawn_position - position
	var warning_dir = spawn_position.rotated(PI)
	var shot_base_dir = Vector2(1,0)#spawn_position.rotated(PI/2)
	
	spawn(warning_scene, spawn_position, [warning_dir])
	await get_tree().create_timer(0.5).timeout
	for i in range(num_shots):
		spawn(
			bullet_scene,
			spawn_position,
			[shot_base_dir.rotated(2*PI/num_shots*i)]
		)

func spawn(scene: PackedScene, spawn_position: Vector2, args: Array):
	var instance = scene.instantiate()
	instance.start(spawn_position, args)
	add_child(instance)
