extends CharacterBody2D
class_name EnemyBullet

@export var speed : int

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_damage_area_body_entered(_body: Node2D) -> void:
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.1).timeout
	queue_free()
