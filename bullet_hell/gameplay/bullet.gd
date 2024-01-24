extends Area2D

const SPEED = 7
var direction: Vector2


## Expect args to contain one Vector2 which represents the direction
func start(start_pos: Vector2, args: Array):
	position = start_pos
	direction = args[0].normalized()
	look_at(direction)

func _ready():
	pass # Replace with function body.


func _process(_delta):
	position += direction * SPEED


func _on_area_exited(_area):
	queue_free()
