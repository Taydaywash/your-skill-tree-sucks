extends CharacterBody2D
class_name Player

@export var move_speed : int
@export var sprite: AnimatedSprite2D

func _ready() -> void:
	pass
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

func _on_player_hitbox_area_entered(_area):
	get_tree().reload_current_scene.call_deferred()
