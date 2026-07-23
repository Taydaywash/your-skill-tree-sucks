extends Node2D
class_name Health

signal health_changed(current_health)
signal death

@export var max_health: int = 100
@onready var health_bar: ProgressBar = $HealthBar
var current_health: int

func _ready() -> void: 
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
	
func take_damage(amount: int) -> void: 
	current_health -= amount
	current_health = max(current_health, 0)
	emit_signal("health_changed", current_health)
	
	if current_health == 0 or current_health < 0:
		emit_signal("death")
