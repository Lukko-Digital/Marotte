extends Node

var bullet_speed_modifier

enum Difficulties { EASY, HARD }

const BULLET_SPEED_OPTIONS = [0.6, 1]

func _ready():
	print(bullet_speed_modifier)
	set_difficulty(Difficulties.EASY)
	print(bullet_speed_modifier)

func set_difficulty(difficulty: Difficulties):
	bullet_speed_modifier = BULLET_SPEED_OPTIONS[difficulty]
