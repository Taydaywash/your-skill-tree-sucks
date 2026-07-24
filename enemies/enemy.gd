extends CharacterBody2D

@export var speed: float = 100
@export var damage_amount: int = 20
@onready var health: Health = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

var player: Player = null

func _ready() -> void:
	player = get_parent().get_node("Player")
	#health_bar.max_value = health.max_health
	#health_bar.value = health.current_health
	
	health.health_changed.connect(on_health_changed)
	health.death.connect(on_death)
	
func _physics_process(_delta):
	if player: 
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func on_health_changed(new_health: int) -> void:
	if not health_bar.visible:
		health_bar.visible = true
	health_bar.value = new_health

func on_death() -> void:
	call_deferred("queue_free")

func _on_hurtbot_area_entered(area):
	health.take_damage(area.damage_amount)
