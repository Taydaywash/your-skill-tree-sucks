extends Button

@onready var default_position = position
@export var button_hold_duration : float
@export var shard_emitter: ShardEmitter
@export var button_shatter: Sprite2D

var shattered := false

var button_hold_timer : Timer

func _ready() -> void:
	button_hold_timer = Timer.new()
	add_child(button_hold_timer)
	button_hold_timer.wait_time = button_hold_duration
	button_hold_timer.autostart = false

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("%s button_press" % [name])

func _on_mouse_entered() -> void:
	if shattered:
		return
	#position.y = default_position.y - 10
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.6,0.6), 0.03).set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	if shattered:
		return
	position.y = default_position.y
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.5,0.5), 0.03).set_ease(Tween.EASE_OUT)
	button_hold_timer.stop()
	button_hold_timer.timeout.emit()

func _on_gui_input(event: InputEvent) -> void:
	if shattered:
		return
	if event is InputEventMouseButton and event.is_pressed():
		button_hold_timer.start()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(0.9,0.9), button_hold_duration - 0.05).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(self, "modulate", Color(1,1,1), button_hold_duration - 0.05).set_ease(Tween.EASE_IN)
		await button_hold_timer.timeout
		if tween.is_running():
			tween.kill()
			var tween2 = get_tree().create_tween()
			tween2.tween_property(self, "scale", Vector2(0.5,0.5), 0.03).set_ease(Tween.EASE_OUT)
			tween2.parallel().tween_property(self, "modulate", Color(0.51, 0.51, 0.51, 1.0), 0.03).set_ease(Tween.EASE_IN)
			return
		else:
			flat = true
			shattered = true
			button_shatter.visible = true
			shard_emitter.shatter()
	if event is InputEventMouseButton and not event.is_pressed():
		button_hold_timer.stop()
		button_hold_timer.timeout.emit()
