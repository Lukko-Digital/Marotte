extends Node2D

@onready var bullet_scene = preload("res://bullet_hell/gameplay/bullet.tscn")
@onready var warning_scene = preload("res://bullet_hell/gameplay/warning.tscn")
@onready var word_scene = preload("res://bullet_hell/gameplay/word_pickup.tscn")
@onready var word_timer: Timer = $WordTimer
@onready var bullet_timer: Timer = $BulletTimer
@onready var player: CharacterBody2D = $bh_player

## Wall Locations
const LEFT_X = 758
const RIGHT_X = 1625
const TOP_Y = 73
const BOTTOM_Y = 914

## Spawn locations
const PLAYER_SPAWN = Vector2(1200, 500)
const WORD_SPAWN_X_OFFSET = 130
const WORD_SPAWN_Y_OFFSET = 80
const Word_Spawn = {
	TOP_LEFT = Vector2(LEFT_X + WORD_SPAWN_X_OFFSET, TOP_Y + WORD_SPAWN_Y_OFFSET),
	BOT_LEFT = Vector2(LEFT_X + WORD_SPAWN_X_OFFSET, BOTTOM_Y - WORD_SPAWN_Y_OFFSET),
	TOP_RIGHT = Vector2(RIGHT_X - WORD_SPAWN_X_OFFSET, TOP_Y + WORD_SPAWN_Y_OFFSET),
	BOT_RIGHT = Vector2(RIGHT_X - WORD_SPAWN_X_OFFSET, BOTTOM_Y - WORD_SPAWN_Y_OFFSET)
}

## Direction enum
const Direction = {
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0),
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1)
}


func _ready():
	bullet_timer.wait_time = 2
	player.position = PLAYER_SPAWN
	Events.word_picked.connect(_on_word_picked)
	word_timer.start()


## Reset upon word pickup
func _on_word_picked(correct):
	if correct:
		get_tree().call_group("bullet", "queue_free")
		get_tree().call_group("word", "queue_free")
		player.position = PLAYER_SPAWN
		word_timer.start()


## Spawn external scene, used for bullets, warnings, and words
func spawn(scene: PackedScene, spawn_position: Vector2, args: Array):
	var instance = scene.instantiate()
	instance.start(spawn_position, args)
	add_child(instance)


## Spawn words in the four corners, with one being incorrect
func spawn_words():
	var word_map = {
		"amogus": true,
		"Among Us": false,
		"mungus": false,
		"Amongus": false
	}
	var spawn_locations = Word_Spawn.values()
	spawn_locations.shuffle()
	
	for word in word_map:
		spawn(
			word_scene,
			spawn_locations.pop_back(),
			[word_map[word], word]
		)


## Word Timer
func _on_word_timer_timeout():
	spawn_words()


## Bullet Timer
func _on_bullet_timer_timeout():
	circle(Direction.values().pick_random(), 8)
	circle(Direction.values().pick_random(), 8)


## Circle shot
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
	
	spawn(warning_scene, spawn_position, [warning_dir])
	await get_tree().create_timer(0.5).timeout
	for i in range(num_shots):
		spawn(
			bullet_scene,
			spawn_position,
			[shot_base_dir.rotated(PI/num_shots*i)]
		)


## Random single shot
func random_from_left():
	var instance = bullet_scene.instantiate()
	instance.start(
		Vector2(LEFT_X, randi_range(TOP_Y, BOTTOM_Y)),
		Vector2(1, randf_range(0,1))
	)
	add_child(instance)
