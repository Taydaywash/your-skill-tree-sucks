extends CharacterBody2D
class_name Player

@export var move_speed : int
@export var sprite: AnimatedSprite2D
@export var invincibility_timer: Timer
@export var hurtbox: Area2D
@export var health: Health 
@export var health_bar: ProgressBar
@export var leveling: Leveling
@export var xp_bar: ProgressBar

var is_invincible: bool = false
var flash_tween: Tween = null
var movement_disabled : bool = false

func _ready() -> void:
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health
	health.health_changed.connect(on_health_changed)
	health.death.connect(on_death)
	
	xp_bar.max_value = leveling.max_xp
	xp_bar.value = leveling.current_xp
	leveling.xp_changed.connect(update_xp_bar)


func _physics_process(_delta: float) -> void:
	if not movement_disabled:
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
	if "damage_amount" in area:
		var damage = area.damage_amount
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
		take_damage(area.damage_amount)

func on_death() -> void:
	get_tree().call_deferred("reload_current_scene")

func update_xp_bar(new_xp: int) -> void:
	xp_bar.value = new_xp
