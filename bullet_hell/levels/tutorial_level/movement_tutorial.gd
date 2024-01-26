extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("pulse")


func _process(delta):
	if (
		Input.is_action_pressed("up") or
		Input.is_action_pressed("down") or
		Input.is_action_pressed("left") or
		Input.is_action_pressed("left")
	):
		animation_player.play("fade")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade": queue_free()
