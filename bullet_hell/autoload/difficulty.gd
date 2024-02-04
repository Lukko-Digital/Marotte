extends Node

var bullet_speed_modifier
var circle_grid_interval

enum Difficulties { EASY, HARD }

const BULLET_SPEED_OPTIONS = [0.7, 1]
const CIRCLE_GRID_INTERVAL_OPTIONS = [1.6 ,1]


func _ready():
	set_difficulty(Difficulties.EASY)


func set_difficulty(difficulty: Difficulties):
	bullet_speed_modifier = BULLET_SPEED_OPTIONS[difficulty]
	circle_grid_interval = CIRCLE_GRID_INTERVAL_OPTIONS[difficulty]
