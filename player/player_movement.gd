extends CharacterBody2D
class_name Player

@export var move_speed : int
@export var sprite: AnimatedSprite2D
@onready var health: Health = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

func _ready() -> void:
	health.health_changed.connect(on_health_changed)
	health.death.connect(on_death)

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = input_dir.normalized() * move_speed
	move_and_slide()
func _process(_delta: float) -> void:
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
		
	if velocity:
		sprite.play("walk")
	else:
		sprite.play("default")

func on_health_changed(new_health: int) -> void:
	health_bar.value = new_health

func _on_player_hitbox_area_entered(area):
	var damage = area.get_parent().damage_amount
	health.take_damage(damage)

func on_death() -> void:
	get_tree().call_deferred("reload_current_scene")
