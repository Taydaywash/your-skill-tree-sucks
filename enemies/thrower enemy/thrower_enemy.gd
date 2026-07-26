extends CharacterBody2D

@export var speed: float = 100
@export var damage_amount: int = 20
@export var xp_orb_scene: PackedScene
@export var follow_distance : int = 400
@export var attack_rate : Array[int] = [3,4]
@export var thrower_enemy_rock: PackedScene
@export var thrower_enemy_bullet: PackedScene
@export var thrower_enemy_harpoon: PackedScene
@export var sprite: AnimatedSprite2D

@onready var health: Health = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

var hooked : bool = false

var default_speed : float

var player: Player = null
var spawner: Node2D = null

@export var particle_controller: Node2D
@export var audio_controller: AudioController
@export var enemy_hit: AudioStreamWAV
@export var enemy_die: AudioStreamWAV
@export var enemy_death_particle: PackedScene

var enemy_alive: bool = true
var knockback: Vector2 = Vector2.ZERO
var orbit_direction = 1

func _ready() -> void:
	EventController.level_down.connect(kill_all_enemies)
	
	#GameState.thrower_enemy_weapon = "harpoon"
	
	default_speed = speed
	player = get_parent().get_node("Player")
	spawner = get_parent().get_node("Spawner")
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health
	
	health.health_changed.connect(on_health_changed)
	health.death.connect(on_death)
	attack_loop()
	
	match GameState.thrower_enemy_weapon:
		"rock":
			attack_rate = [3,4]
		"gun":
			attack_rate = [2,4]
		"harpoon":
			attack_rate = [2,3]
			
	EventController.connect("reverse_gun",func ():
		GameState.thrower_enemy_weapon = "gun"
	)
	EventController.connect("reverse_harpoon",func ():
		GameState.thrower_enemy_weapon = "harpoon"
	)
	
	follow_distance += randi_range(-100,100)
	orbit_direction = randi_range(-1,1)

func attack_loop():
	match GameState.thrower_enemy_weapon:
		"rock":
			var projectile_instance = thrower_enemy_rock.instantiate()
			get_tree().current_scene.call_deferred("add_child", projectile_instance)
			projectile_instance.global_position = global_position
			var direction: Vector2 = (player.global_position - global_position).normalized()
			projectile_instance.position += direction * 30
			projectile_instance.velocity = direction * projectile_instance.speed
		"gun":
			var projectile_instance = thrower_enemy_bullet.instantiate()
			get_tree().current_scene.call_deferred("add_child", projectile_instance)
			projectile_instance.global_position = global_position
			var direction: Vector2 = (player.global_position - global_position).normalized()
			projectile_instance.velocity = direction * projectile_instance.speed
		"harpoon":
			var projectile_instance = thrower_enemy_harpoon.instantiate()
			projectile_instance.parent_enemy = self
			get_tree().current_scene.call_deferred("add_child", projectile_instance)
			projectile_instance.global_position = global_position
			var direction: Vector2 = (player.global_position - global_position).normalized()
			projectile_instance.velocity = direction * projectile_instance.speed
	await get_tree().create_timer(randf_range(attack_rate[0],attack_rate[1])).timeout
	attack_loop()

func _physics_process(delta):
	if player.global_position.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	if player: 
		var direction: Vector2 = (player.global_position - global_position).normalized()
		if (player.global_position - global_position).length() > follow_distance:
			velocity = direction * speed
		elif (player.global_position - global_position).length() > (follow_distance - 100):
			velocity = Vector2.ZERO
			velocity += direction.rotated(PI/2) * speed * orbit_direction
		else:
			velocity = direction * -speed * 2
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
	enemy_alive = false
	visible = false
	await get_tree().create_timer(0.5).timeout
	call_deferred("queue_free")

func _on_hurtbot_area_entered(area):
	if area.pull_enemy:
		follow_distance = 200
		speed = 50
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
