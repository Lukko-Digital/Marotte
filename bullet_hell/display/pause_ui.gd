extends Control

@onready var are_you_sure: Control = $are_you_sure

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		are_you_sure.visible = false
		visible = !visible
		get_tree().paused = !get_tree().paused
		$Resume.grab_focus()


func _on_quit_pressed():
	are_you_sure.start()


func _on_resume_pressed():
	visible = false
	get_tree().paused = false


func _on_are_you_sure_dont_quit():
	$Resume.grab_focus()
