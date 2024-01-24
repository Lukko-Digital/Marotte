extends CharacterBody2D

@onready var hitbox: Area2D = $HitBox
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

const SPEED = 300.0

signal hit

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	handle_animation(direction)
	velocity = direction * SPEED
	
	move_and_slide()

func handle_animation(direction: Vector2):
	if direction == Vector2():
		# still
		animation_player.play("idle")
	elif direction.x > 0:
		# right
		animation_player.play("run_left")
		sprite.flip_h = true
	else:
		# left
		animation_player.play("run_left")
		sprite.flip_h = false

func _on_hit_box_area_entered(area):
	if area.is_in_group("bullet"):
		emit_signal("hit")
		modulate = Color(1,0,0)
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1,1,1)
