extends Node

var bullet_speed_modifier

enum Difficulties { EASY, HARD }

const BULLET_SPEED_OPTIONS = [0.7, 1]

func _ready():
	set_difficulty(Difficulties.EASY)

func set_difficulty(difficulty: Difficulties):
	bullet_speed_modifier = BULLET_SPEED_OPTIONS[difficulty]
