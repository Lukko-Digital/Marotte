extends Area2D

var speed: int

var player: CharacterBody2D

var offset: Vector2

@onready var timer: Timer = $Timer


## Expect args to contain one Vector2 which represents the direction
func start(start_pos: Vector2, args: Array):
	position = start_pos
	player = args[0]
	speed = args[1] * 500
	offset = args[2]
#	print(position)

func _physics_process(delta):
	look_at(player.position)
	modulate = Color(1,1,1,timer.wait_time/5)
	
	var direction = (player.position - (position + offset)).normalized()
	position += direction * speed * delta


func _on_timer_timeout():
	queue_free()
