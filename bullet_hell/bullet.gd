extends Area2D

const SPEED = 400
var direction: Vector2

func start(start_pos: Vector2, dir: Vector2):
	position = start_pos
	direction = dir
	look_at(direction)

func _ready():
	pass # Replace with function body.


func _process(delta):
	position += direction * SPEED
