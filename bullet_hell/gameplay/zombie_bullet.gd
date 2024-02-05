extends Area2D

var speed: int

var player: CharacterBody2D

var direction: Vector2
var offset: Vector2

var running: bool

@onready var timer: Timer = $Timer
@onready var sprite: AnimatedSprite2D = $Sprite2D


## Expect args to contain one Vector2 which represents the direction
func start(start_pos: Vector2, args: Array):
	position = start_pos
	player = args[0]
	speed = args[1] * 500 * Difficulty.bullet_speed_modifier
	offset = args[2]
	await ready 
	sprite.play("default")
#	print(position)

func _physics_process(delta):
	if !running:
		look_at(player.position)
		direction = (player.position - (position + offset)).normalized()
	
	position += direction * speed * delta


func _on_timer_timeout():
	sprite.play("run")
	await get_tree().create_timer(3.4).timeout
	running = true
	speed *= 2
