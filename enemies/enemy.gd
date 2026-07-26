extends CharacterBody2D

@export var speed: float = 100
@export var damage_amount: int = 20
@export var xp_orb_scene: PackedScene
@export var sprite: AnimatedSprite2D

@onready var health: Health = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

var hooked : bool = false

var default_speed : float

var player: Player = null
var spawner: Node2D = null

@export var audio_controller: AudioController
@export var enemy_hit: AudioStreamWAV
@export var enemy_die: AudioStreamWAV
@export var enemy_death_particle: PackedScene
@export var particle_controller: Node2D

@export var spear: Sprite2D

@export var sword: AnimatedSprite2D
@export var sword_damage_area: Area2D
@export var sword_player_detection: Area2D

@export var hitbox: Area2D

var enemy_alive :bool = true
var knockback: Vector2 = Vector2.ZERO

var follow_accuracy : float = 1

func _ready() -> void:
	EventController.level_down.connect(kill_all_enemies)
	EventController.connect("reverse_sword",func ():
		GameState.melee_enemy_weapon = "sword"
	)
	EventController.connect("reverse_spear",func ():
		GameState.melee_enemy_weapon = "spear"
	)
	
	default_speed = speed
	player = get_parent().get_node("Player")
	spawner = get_parent().get_node("Spawner")
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health
	
	health.health_changed.connect(on_health_changed)
	health.death.connect(on_death)
	follow_accuracy = randf_range(-0.5,0.5)
	
	if GameState.melee_enemy_weapon == "sword":
		if randi_range(0,100) <= 50:
			sword.visible = true
			sword_player_detection.set_deferred("monitoring",true)
	if GameState.melee_enemy_weapon == "spear":
		if randi_range(0,100) <= 50:
			health.current_health /= 2
			spear.visible = true
			spear.get_child(0).set_deferred("monitorable", true)
		elif randi_range(0,100) <= 50:
			sword.visible = true
			sword_player_detection.set_deferred("monitoring",true)
	
func _physics_process(delta):
	spear.look_at(player.global_position)
	spear.rotate(deg_to_rad(82.0))
	sword.look_at(player.global_position)
	
	if not enemy_alive:
		return
	if player.global_position.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	if player: 
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * speed
		velocity += direction.rotated(PI/2) * speed * follow_accuracy
		if knockback != Vector2.ZERO:
			velocity = knockback        
			knockback = knockback.move_toward(Vector2.ZERO, 500 * delta)
		move_and_slide()

func on_health_changed(new_health: int) -> void:
	health_bar.value = new_health
	if not health_bar.visible:
		health_bar.visible = true

func on_death() -> void:
	audio_controller.play_sound(enemy_die)
	spawn_xp_orb()
	spawner.current_enemy_count -= 1
	hitbox.set_deferred("monitorable",false)
	enemy_alive = false
	visible = false
	await get_tree().create_timer(0.5).timeout
	call_deferred("queue_free")

func _on_hurtbot_area_entered(area):
	if area.pull_enemy:
		speed = default_speed * 2 + speed/5
	knockback = (global_position - area.global_position).normalized() * area.knockback_power
	particle_controller.spawn_particle(enemy_death_particle)
	audio_controller.play_sound(enemy_hit)
	health.take_damage(area.damage_amount)

func spawn_xp_orb() -> void:
	var xp_orb = xp_orb_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", xp_orb)
	xp_orb.global_position = global_position

func kill_all_enemies() -> void:
	call_deferred("queue_free")

func _on_sword_player_detection_body_entered(_body: Node2D) -> void:
	print("attack")
	sword.play("default")
	sword_damage_area.position = Vector2.ZERO
	await get_tree().create_timer(0.2).timeout
	sword_damage_area.position = Vector2.INF
