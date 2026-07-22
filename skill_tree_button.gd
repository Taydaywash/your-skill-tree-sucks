extends Button

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("%s button_press" % [name])

func _on_mouse_entered() -> void:
	position.y = -10

func _on_mouse_exited() -> void:
	position.y = 0
