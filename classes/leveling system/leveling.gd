extends Node2D
class_name Leveling

@export var level_counter: Label

signal xp_changed(current_xp: int)

var player_level: int = 7
var max_xp: int = 1

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
	player_level -= 1
	level_counter.text = "LVL %s" %[player_level]
	current_xp = current_xp % max_xp
	EventController.emit_signal("level_down")
