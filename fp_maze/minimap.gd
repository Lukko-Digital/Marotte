extends Control

@export var player : CharacterBody3D
@onready var mini_player : Sprite2D = $Player


func _process(delta):
	mini_player.rotation = -deg_to_rad(player.rotation_degrees.y)
