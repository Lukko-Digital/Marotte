extends Node2D

@onready var bullet_scene = preload("res://bullet_hell/gameplay/bullet.tscn")
@onready var warning_scene = preload("res://bullet_hell/gameplay/warning.tscn")
@onready var word_scene = preload("res://bullet_hell/gameplay/word_pickup.tscn")
@onready var timer: Timer = $BulletTimer
@onready var player: CharacterBody2D = $bh_player

const LEFT_X = 758
const RIGHT_X = 1625
const TOP_Y = 73
const BOTTOM_Y = 914

const PLAYER_SPAWN = Vector2(1200, 500)

const WORD_SPAWN_X_OFFSET = 130
const WORD_SPAWN_Y_OFFSET = 80

const Word_Spawn = {
	TOP_LEFT = Vector2(LEFT_X + WORD_SPAWN_X_OFFSET, TOP_Y + WORD_SPAWN_Y_OFFSET),
	BOT_LEFT = Vector2(LEFT_X + WORD_SPAWN_X_OFFSET, BOTTOM_Y - WORD_SPAWN_Y_OFFSET),
	TOP_RIGHT = Vector2(RIGHT_X - WORD_SPAWN_X_OFFSET, TOP_Y + WORD_SPAWN_Y_OFFSET),
	BOT_RIGHT = Vector2(RIGHT_X - WORD_SPAWN_X_OFFSET, BOTTOM_Y - WORD_SPAWN_Y_OFFSET)
}

const Direction = {
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0),
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1)
}

func _ready():
	timer.wait_time = 2
	player.position = PLAYER_SPAWN
	Events.correct_word_picked.connect(_reset)

func _process(delta):
	pass

func _reset():
	get_tree().call_group("bullet", "queue_free")
	player.position = PLAYER_SPAWN
	spawn(word_scene, Word_Spawn.values().pick_random(), Vector2())

func _on_timer_timeout():
	circle(Direction.values().pick_random(), 8)
	circle(Direction.values().pick_random(), 8)

func circle(direction: Vector2, num_shots=12):
	var spawn_position: Vector2
	var warning_dir = direction.rotated(PI)
	var shot_base_dir = direction.rotated(PI/2)
	
	match direction:
		Direction.LEFT:
			spawn_position = Vector2(LEFT_X, randi_range(TOP_Y, BOTTOM_Y))
		Direction.RIGHT:
			spawn_position = Vector2(RIGHT_X, randi_range(TOP_Y, BOTTOM_Y))
		Direction.UP:
			spawn_position = Vector2(randi_range(LEFT_X, RIGHT_X), TOP_Y)
		Direction.DOWN:
			spawn_position = Vector2(randi_range(LEFT_X, RIGHT_X), BOTTOM_Y)
	
	spawn(warning_scene, spawn_position, warning_dir)
	await get_tree().create_timer(0.5).timeout
	for i in range(num_shots):
		spawn(
			bullet_scene,
			spawn_position,
			shot_base_dir.rotated(PI/num_shots*i)
		)

func random_from_left():
	var instance = bullet_scene.instantiate()
	instance.start(
		Vector2(LEFT_X, randi_range(TOP_Y, BOTTOM_Y)),
		Vector2(1, randf_range(0,1))
	)
	add_child(instance)

func spawn(scene: PackedScene, position: Vector2, direction: Vector2):
	var instance = scene.instantiate()
	instance.start(position, direction)
	add_child(instance)
