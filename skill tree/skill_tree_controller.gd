extends Node2D

@export var health_bar: ProgressBar

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		visible = !visible
		health_bar.visible = !visible
