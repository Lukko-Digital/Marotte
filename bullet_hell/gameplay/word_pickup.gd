extends Area2D

@onready var label: Label = $Label
@onready var hitbox: CollisionShape2D = $CollisionShape2D

const CHAR_WIDTH = 19
const HITBOX_SCALE = 0.8
const HITBOX_HEIGHT = 25

var correct
var word
var joke_text
var red = false

## Expect args to contain two elements
## 1. A bool which indicates if the word is the correct word
## 2. A string which represents the word to be displayed
## 3. A string representing joke text to display when the word is picked if the word is correct,
## 		otherwise null
func start(start_pos: Vector2, args: Array):
	position = start_pos
	correct = args[0]
	if args[1][0] == "#":
		word = args[1].substr(1)
		red = true
	else:
		word = args[1]
	joke_text = args[2]


func _ready():
	label.text = word
	if red: label.add_theme_color_override("font_color", Color("ff6363"))
	var rect = RectangleShape2D.new()
	rect.size = Vector2(len(label.text) * CHAR_WIDTH, HITBOX_HEIGHT) * HITBOX_SCALE
	hitbox.shape = rect


func _on_body_entered(_body):
	Events.emit_signal("word_picked", correct, joke_text)
	queue_free()
