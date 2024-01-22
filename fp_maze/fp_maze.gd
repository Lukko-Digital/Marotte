extends Node3D

@onready var spawn_points = $SpawnPoints.get_children()
@onready var word_scene = preload("res://fp_maze/fp_maze_word.tscn")
var current_spawn

var word

func spawn_word():
	word = word_scene.instantiate()
	add_child(word)
	
	current_spawn = spawn_points.pop_front()
	word.position = current_spawn.position
	
	spawn_points.shuffle()
	spawn_points.append(current_spawn)
	
	word.entered.connect(spawn_word)

func _ready():
	spawn_points.shuffle()
	
	
	spawn_word()

