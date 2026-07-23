extends Button

@onready var default_position = position
@export var button_hold_duration : float
@export var shard_emitter: ShardEmitter
@export var button_shatter: Sprite2D

@export var info_panel: Panel
@export var required_nodes : Array[Button]
@export var animation_player: AnimationPlayer

var shattered := false
var unlocked := false #For Error Prevention Only

var button_hold_timer : Timer

func _ready() -> void:
	button_hold_timer = Timer.new()
	add_child(button_hold_timer)
	button_hold_timer.wait_time = button_hold_duration
	button_hold_timer.autostart = false

func _process(_delta: float) -> void:
	for node in required_nodes:
			if not node.shattered:
				return
	if not shattered and not unlocked:
		self_modulate = Color(0.8,0.8,0.8)

func _on_mouse_entered() -> void:
	info_panel.emit_signal("skill_hovered",name,"empty")
	if shattered:
		return
	for node in required_nodes:
		if not node.shattered:
			@warning_ignore("confusable_local_declaration")
			var tween = get_tree().create_tween()
			tween.tween_property(self, "scale", Vector2(0.55,0.55), 0.03).set_ease(Tween.EASE_OUT)
			return
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
		for node in required_nodes:
			if not node.shattered:
				animation_player.play("cant interact")
				return
		button_hold_timer.start()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(0.9,0.9), button_hold_duration - 0.05).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(self, "self_modulate", Color(1,1,1), button_hold_duration - 0.05).set_ease(Tween.EASE_IN)
		await button_hold_timer.timeout
		if tween.is_running():
			tween.kill()
			var tween2 = get_tree().create_tween()
			tween2.tween_property(self, "scale", Vector2(0.5,0.5), 0.03).set_ease(Tween.EASE_OUT)
			tween2.parallel().tween_property(self, "self_modulate", Color(0.51, 0.51, 0.51, 1.0), 0.03).set_ease(Tween.EASE_IN)
			return
		else:
			shattered = true
			button_shatter.visible = true
			var tween2 = get_tree().create_tween()
			tween2.tween_property(self, "scale", Vector2(0.5,0.5), 0.03).set_ease(Tween.EASE_OUT)
			tween2.parallel().tween_property(self, "self_modulate", Color(0.2, 0.2, 0.2, 1.0), 0.03).set_ease(Tween.EASE_IN)
			shard_emitter.shatter()
	if event is InputEventMouseButton and not event.is_pressed():
		button_hold_timer.stop()
		button_hold_timer.timeout.emit()
