extends Label3D

signal entered

func _on_area_3d_body_entered(body):
	entered.emit()

	queue_free()
