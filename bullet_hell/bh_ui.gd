extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar
@onready var color_animation: AnimationPlayer = $ScreenColor/AnimationPlayer

const MAX_HP = 10
var current_hp = MAX_HP

func _ready():
	health_bar.max_value = MAX_HP
	health_bar.value = MAX_HP


func _process(delta):
	if current_hp <= MAX_HP/5:
		color_animation.speed_scale = 2
		color_animation.play("pulse")
	elif current_hp <= MAX_HP/2:
		color_animation.play("pulse")


func _on_bh_player_hit():
	current_hp -= 1
	health_bar.value = current_hp
