extends CharacterBody2D

const SPEED = 300.0


func _physics_process(delta):

	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	velocity = direction * SPEED

	move_and_slide()
