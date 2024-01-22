extends Control

@export var player : CharacterBody3D
@onready var mini_player : Sprite2D = $Player
@onready var map : TextureRect = $Minimap


func _process(delta):
	mini_player.rotation = -deg_to_rad(player.rotation_degrees.y)
	mini_player.position = Vector2(player.position.x, player.position.z) + map.size/2
