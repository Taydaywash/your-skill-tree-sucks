extends AnimatedSprite2D

var current_weapon = "spear"

func _process(_delta: float) -> void:
	position = (get_global_mouse_position() - get_parent().global_position).normalized() * 20
	match current_weapon:
		"spear":
			look_at(get_parent().global_position)
			rotate(PI)
		"fist":
			rotation = 0
		"sword":
			rotation = 0
func _input(event: InputEvent) -> void:
	if event.is_action("melee_attack"):
		match current_weapon:
			"spear":
				play("spear_idle")
			"sword":
				play("sword_idle")
			"fist":
				play("fist_idle")
