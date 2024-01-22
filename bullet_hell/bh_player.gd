extends CharacterBody2D

@onready var hitbox: Area2D = $HitBox

const SPEED = 300.0

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	velocity = direction * SPEED
	
	move_and_slide()

func _on_hit_box_area_entered(area):
	if area.is_in_group("bullet"):
		modulate = Color(1,0,0)
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1,1,1)
