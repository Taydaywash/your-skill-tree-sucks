extends CharacterBody2D
class_name Player

@export var move_speed : int
var default_speed : int
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
var player_disabled : bool = false

#Dash
@export_category("Dash")
@export var dash_speed : int
@export var dash_duration : float #seconds
@export var short_dash_duration : float #seconds
var dash_timer : Timer
var dash_direction: Vector2 = Vector2.ZERO
var dash_cooldown_timer : Timer
@export var dash_cooldown_timer_wait : float

var dash_disabled: bool = false

var step_audio_cooldown : Timer
@export var audio_controller: AudioController
@export var step: AudioStreamWAV


func _ready() -> void:
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health
	health.health_changed.connect(on_health_changed)
	health.death.connect(on_death)
	
	xp_bar.max_value = leveling.max_xp
	xp_bar.value = leveling.current_xp
	leveling.xp_changed.connect(update_xp_bar)
	
	dash_timer = Timer.new()
	dash_timer.wait_time = dash_duration
	dash_timer.one_shot = true
	add_child(dash_timer)
	
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.wait_time = dash_cooldown_timer_wait
	dash_cooldown_timer.one_shot = true
	add_child(dash_cooldown_timer)
	
	step_audio_cooldown = Timer.new()
	step_audio_cooldown.wait_time = 0.25
	step_audio_cooldown.one_shot = true
	add_child(step_audio_cooldown)
	
	default_speed = move_speed
	move_speed = 1
	
	EventController.connect("remove_chains",func():
		move_speed = default_speed
		)
	
	EventController.connect("remove_long_dash", func():
		dash_timer.wait_time = short_dash_duration
		)
	
	EventController.connect("level_down", func():
		health.heal_to_full()
	)
	
func disable_dash() -> void:
	dash_disabled = true

func _physics_process(_delta: float) -> void:
	if not movement_disabled:
		var input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
		velocity = input_dir.normalized() * move_speed
	move_and_slide()
	if velocity.length() > 10:
		if not step_audio_cooldown.time_left:
			step_audio_cooldown.start()
			audio_controller.play_sound(step)
			
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

func _input(event: InputEvent) -> void:
	if player_disabled:
		return
	
	if event.is_action_pressed("dash") and not player_disabled:
		if dash_disabled:
			return
		if dash_cooldown_timer.time_left:
			return
		dash_cooldown_timer.start()
		movement_disabled = true
		#player.is_invincible = true
		dash_direction = global_position.direction_to(get_global_mouse_position())
		velocity = dash_direction * dash_speed
		dash_timer.start()
		await dash_timer.timeout
		movement_disabled = false
		is_invincible = false
		velocity = Vector2.ZERO
