extends CharacterBody2D

@onready var hitbox: Area2D = $HitBox
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var walk_sound: AudioStreamPlayer = $WalkSound
@onready var invuln_timer: Timer = $InvulnTimer

const SPEED = 300.0
const INVULN_DURATION = 0.5

signal hit

func _ready():
	invuln_timer.wait_time = INVULN_DURATION
	Events.level_complete.connect(_on_level_complete)


func _physics_process(_delta):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	handle_animation(direction)
	velocity = direction * SPEED
	move_and_slide()


func handle_animation(direction: Vector2):
	match direction.round():
		Vector2():
			animation_player.play("idle")
		Vector2(1,-1), Vector2(1,0), Vector2(1,1):
			# right
			animation_player.play("run_left")
			sprite.flip_h = true
		Vector2(-1,-1), Vector2(-1,0), Vector2(-1,1):
			# left
			animation_player.play("run_left")
			sprite.flip_h = false
		Vector2(0,-1):
			# up
			animation_player.play("run_up")
		Vector2(0,1):
			# down
			animation_player.play("run_down")
	if direction != Vector2():
		walk_sound.play()


func on_hit():
	invuln_timer.start()
	emit_signal("hit")
	hit_sound.play()
	modulate = Color(Color.RED, 0.75)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(Color.WHITE, 0.5)


func _on_invuln_timer_timeout():
	modulate = Color(Color.WHITE)


func _on_hit_box_area_entered(area):
	if area.is_in_group("bullet") and invuln_timer.is_stopped():
		area.queue_free()
		on_hit()
	elif area.is_in_group("wall_bullet") and invuln_timer.is_stopped():
		on_hit()

func _on_level_complete():
	invuln_timer.start(3)
