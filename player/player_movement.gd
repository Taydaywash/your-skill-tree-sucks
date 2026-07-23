extends CharacterBody2D
class_name Player

@export var move_speed : int
@export var sprite: AnimatedSprite2D
@export var invincibility_timer: Timer
@export var hurtbox: Area2D

@onready var health: Health = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

var is_invincible: bool = false
var flash_tween: Tween = null

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

func _on_player_hurtbox_area_entered(area):
	var area_parent = area.get_parent()
	if "damage_amount" in area_parent:
		var damage = area_parent.get("damage_amount")
		take_damage(damage)

func take_damage(amount: int) -> void:
	if not is_invincible: 
		print("taken damage ", amount)
		health.take_damage(amount)
		start_invincibility()

func start_invincibility() -> void:
	is_invincible = true
	invincibility_timer.start()
	
	var tween = create_tween().set_loops()
	tween.tween_property(sprite, "modulate:a", 0.2, 0.1)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
	
	await invincibility_timer.timeout
	is_invincible = false
	tween.kill()
	sprite.modulate.a = 1.0
	
	for area in hurtbox.get_overlapping_areas():
		var area_parent = area.get_parent()
		if area_parent.is_in_group("Enemy"):
			take_damage(area_parent.damage_amount)
			break

func on_death() -> void:
	get_tree().call_deferred("reload_current_scene")

func _on_invincibility_timer_timeout():
	pass # Replace with function body.
