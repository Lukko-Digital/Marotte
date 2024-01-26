extends Area2D

var speed = 500
var direction: Vector2


## Expect args to contain one Vector2 which represents the direction
func start(start_pos: Vector2, args: Array):
	position = start_pos
	direction = args[0].normalized()
	
	if len(args) > 1:
		speed = args[1]
	
	look_at(direction)

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position += direction * speed * delta


func _on_area_exited(_area):
	queue_free()
