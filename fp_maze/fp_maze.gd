extends Node3D

@onready var spawn_points = $SpawnPoints.get_children()
@onready var word_scene = preload("res://fp_maze/fp_maze_word.tscn")
@onready var nav_region : NavigationRegion3D = $NavigationRegion3D

@onready var enemy : CharacterBody3D = $fp_maze_enemy
@onready var player : CharacterBody3D = $Player

var current_spawn
var word

signal word_spawned(new_word)

func spawn_word():
	word = word_scene.instantiate()
	add_child(word)
	
	current_spawn = spawn_points.pop_front()
	word.position = current_spawn.position
	
	spawn_points.shuffle()
	spawn_points.append(current_spawn)
	
	word_spawned.emit(word)
	word.entered.connect(spawn_word)

func _ready():
	spawn_points.shuffle()
	
	spawn_word()
	
	call_deferred("set_up_nav_server")

func set_up_nav_server():
	# create a new navigation map
	var map: RID = NavigationServer3D.map_create()
	NavigationServer3D.map_set_up(map, Vector3.UP)
	NavigationServer3D.map_set_active(map, true)

	nav_region.update_navigation_mesh()
	
	await get_tree().physics_frame
