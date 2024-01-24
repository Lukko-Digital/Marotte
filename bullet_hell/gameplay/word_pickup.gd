extends Area2D

@onready var label: Label = $Label

var correct
var word

## Expect args to contain two elements
## 1. A bool which indicates if the word is the correct word
## 2. A string which represents the word to be displayed
func start(start_pos: Vector2, args: Array):
	position = start_pos
	correct = args[0]
	word = args[1]

func _ready():
	label.text = word

func _on_body_entered(_body):
	Events.emit_signal("word_picked", correct)
	queue_free()
