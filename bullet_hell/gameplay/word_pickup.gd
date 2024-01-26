extends Area2D

@onready var label: Label = $Label

var correct
var word
var joke_text

## Expect args to contain two elements
## 1. A bool which indicates if the word is the correct word
## 2. A string which represents the word to be displayed
## 3. A string representing joke text to display when the word is picked if the word is correct,
## 		otherwise null
func start(start_pos: Vector2, args: Array):
	position = start_pos
	correct = args[0]
	word = args[1]
	joke_text = args[2]


func _ready():
	label.text = word


func _on_body_entered(_body):
	Events.emit_signal("word_picked", correct)
	queue_free()
