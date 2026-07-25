extends CharacterBody2D

@export var speed: float = 100
@export var damage_amount: int = 20
@export var xp_orb_scene: PackedScene
@export var follow_distance : int
@export var thrower_enemy_rock: PackedScene

@onready var health: Health = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

var hooked : bool = false

var default_speed : float

var player: Player = null

func _ready() -> void:
	default_speed = speed
	player = get_parent().get_node("Player")
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health
	
	health.health_changed.connect(on_health_changed)
	health.death.connect(on_death)
	attack_loop()

func attack_loop():
	var projectile_instance = thrower_enemy_rock.instantiate()
	get_tree().current_scene.call_deferred("add_child", projectile_instance)
	projectile_instance.global_position = global_position
	var direction: Vector2 = (player.global_position - global_position).normalized()
	projectile_instance.velocity = direction * projectile_instance.speed
	await get_tree().create_timer(randf_range(1,4)).timeout
	attack_loop()

func _physics_process(_delta):
	if player: 
		if (player.global_position - global_position).length() > follow_distance:
			var direction: Vector2 = (player.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			var direction: Vector2 = (player.global_position - global_position).normalized()
			velocity = direction * -speed
			velocity += direction.rotated(PI/2) * speed
		move_and_slide()

func on_health_changed(new_health: int) -> void:
	health_bar.value = new_health
	if not health_bar.visible:
		health_bar.visible = true

func on_death() -> void:
	spawn_xp_orb()
	call_deferred("queue_free")

func _on_hurtbot_area_entered(area):
	if area.pull_enemy:
		follow_distance = 0
		speed = default_speed * 2 + speed/5
	health.take_damage(area.damage_amount)

func spawn_xp_orb() -> void:
	var xp_orb = xp_orb_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", xp_orb)
	xp_orb.global_position = global_position
