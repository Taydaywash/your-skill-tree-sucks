extends Node2D
class_name Leveling

signal xp_changed(current_xp: int)

var starting_level: int = 10
var max_xp: int = 10

var current_xp: int = 0
var extra_xp: int = 0

func _ready() -> void:
	EventController.pick_up_xp_orb.connect(xp_orb_collected)
	
func xp_orb_collected() -> void:
	current_xp += 1
	if current_xp >= max_xp:
		level_down()
	emit_signal("xp_changed", current_xp)

func level_down() -> void:
	starting_level -= 1
	current_xp = current_xp % max_xp
	EventController.emit_signal("level_down")
