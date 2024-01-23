extends Control

@export var player : CharacterBody3D
@export var enemy : CharacterBody3D
@onready var mini_player : Sprite2D = $Player
@onready var mini_enemy : Sprite2D = $Enemy
@onready var map : TextureRect = $Minimap
@onready var word : Sprite2D = $Word


func _process(delta):
	mini_player.rotation = -deg_to_rad(player.rotation_degrees.y)
	mini_player.position = Vector2(player.position.x, player.position.z) + map.size/2
	mini_enemy.position = Vector2(enemy.position.x, enemy.position.z) + map.size/2


func _on_fp_maze_word_spawned(new_word):
	word.position = Vector2(new_word.position.x, new_word.position.z) + map.size/2
