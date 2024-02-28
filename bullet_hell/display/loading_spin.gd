extends Sprite2D

@onready var animation_player : AnimationPlayer = get_parent()

func _ready():
	visible = false
	animation_player.animation_finished.connect(loading)

func _process(delta):
	rotation += delta * 5

func loading(_anim_name):
	if (_anim_name == "end"):
		visible = true
