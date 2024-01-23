extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar

const MAX_HP = 10
var current_hp = MAX_HP

func _ready():
	health_bar.max_value = MAX_HP
	health_bar.value = MAX_HP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bh_player_hit():
	current_hp -= 1
	health_bar.value = current_hp
