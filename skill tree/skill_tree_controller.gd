extends Node2D

@export var health_bar: ProgressBar
@export var xp_bar: ProgressBar
@export var level_counter: Label

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		visible = !visible
		health_bar.visible = !visible
		xp_bar.visible = !visible
		level_counter.visible = !visible
