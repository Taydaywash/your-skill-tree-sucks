extends CharacterBody2D

@export var speed: float = 100
var player: Player = null

func _ready() -> void:
	player = get_parent().get_node("Player")
	
func _physics_process(_delta):
	if player: 
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
