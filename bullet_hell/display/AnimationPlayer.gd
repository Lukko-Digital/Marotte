extends AnimationPlayer


func _ready():
	await get_tree().create_timer(0.5).timeout
	play("start")

