extends CharacterBody2D

@onready var hitbox: Area2D = $HitBox
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var walk_sound: AudioStreamPlayer = $WalkSound

const SPEED = 300.0

signal hit

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

func _on_hit_box_area_entered(area):
	if area.is_in_group("bullet"):
		area.queue_free()
		emit_signal("hit")
		hit_sound.play()
		modulate = Color(1,0,0,0.75)
		hitbox.collision_mask = 0
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1,1,1,0.75)
		await get_tree().create_timer(0.4).timeout
		modulate = Color(1,1,1)
		hitbox.collision_mask = 5
	elif area.is_in_group("wall_bullet"):
		emit_signal("hit")
		hit_sound.play()
		modulate = Color(1,0,0,0.75)
		hitbox.collision_mask = 0
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1,1,1,0.75)
		await get_tree().create_timer(0.4).timeout
		modulate = Color(1,1,1)
		hitbox.collision_mask = 5
