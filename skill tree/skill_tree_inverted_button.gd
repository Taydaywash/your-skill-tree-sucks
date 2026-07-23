extends Button

@onready var default_position = position
@export var button_hold_duration : float

@export var required_nodes : Array[Button]
@export var inverted_animation_player: AnimationPlayer
@export var sprite: Sprite2D

var shattered := false #For Error Prevention Only
var unlocked := false

var button_hold_timer : Timer

func _ready() -> void:
	button_hold_timer = Timer.new()
	add_child(button_hold_timer)
	button_hold_timer.wait_time = button_hold_duration
	button_hold_timer.autostart = false

func _process(_delta: float) -> void:
	if visible:
		return
	for node in required_nodes:
		if not node.shattered and not node.unlocked:
			return
	visible = true
	self_modulate = Color(1,1,1,0)
	scale = Vector2(0.2,0.2)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.5,0.5), 0.2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "self_modulate", Color(0.51, 0.51, 0.51, 1.0), 0.03).set_ease(Tween.EASE_IN)

func _on_mouse_entered() -> void:
	if unlocked:
		return
	for node in required_nodes:
		if not node.shattered and not node.unlocked:
			@warning_ignore("confusable_local_declaration")
			var tween = get_tree().create_tween()
			tween.tween_property(self, "scale", Vector2(0.55,0.55), 0.03).set_ease(Tween.EASE_OUT)
			return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.6,0.6), 0.03).set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	if unlocked:
		return
	position.y = default_position.y
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.5,0.5), 0.03).set_ease(Tween.EASE_OUT)
	button_hold_timer.stop()
	button_hold_timer.timeout.emit()

func _on_gui_input(event: InputEvent) -> void:
	if unlocked:
		return
	if event is InputEventMouseButton and event.is_pressed():
		for node in required_nodes:
			if not node.shattered and not node.unlocked:
				inverted_animation_player.play("cant interact")
				return
		button_hold_timer.start()
		inverted_animation_player.play("build")
		await button_hold_timer.timeout
		if inverted_animation_player.is_playing():
			inverted_animation_player.stop()
			var tween2 = get_tree().create_tween()
			tween2.tween_property(self, "scale", Vector2(0.5,0.5), 0.03).set_ease(Tween.EASE_OUT)
			tween2.parallel().tween_property(self, "self_modulate", Color(0.51, 0.51, 0.51, 1.0), 0.03).set_ease(Tween.EASE_IN)
			return
		else:
			unlocked = true
			inverted_animation_player.play("RESET")
			var tween2 = get_tree().create_tween()
			tween2.tween_property(self, "scale", Vector2(0.5,0.5), 0.03).set_ease(Tween.EASE_OUT)
			tween2.parallel().tween_property(self, "self_modulate", Color(1, 1, 1, 1.0), 0.03).set_ease(Tween.EASE_IN)
	if event is InputEventMouseButton and not event.is_pressed():
		button_hold_timer.stop()
		button_hold_timer.timeout.emit()
