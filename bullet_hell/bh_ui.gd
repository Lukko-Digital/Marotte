extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar
@onready var color_animation: AnimationPlayer = $ScreenColor/AnimationPlayer
@onready var player_image: TextureRect = $UIPlayer

@export var low_stress: CompressedTexture2D
@export var high_stress: CompressedTexture2D

const MAX_HP = 10
var current_hp = MAX_HP

func _ready():
	health_bar.max_value = MAX_HP
	health_bar.value = MAX_HP
	player_image.texture = low_stress


func _process(delta):
	if current_hp <= MAX_HP/5:
		color_animation.speed_scale = 2
		color_animation.play("pulse")
	elif current_hp <= MAX_HP/2:
		color_animation.play("pulse")
		player_image.texture = high_stress


func _on_bh_player_hit():
	current_hp -= 1
	health_bar.value = current_hp
