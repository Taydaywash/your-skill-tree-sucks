extends CharacterBody2D
class_name EnemyBullet

@export var speed : int

func _ready() -> void:
	await get_tree().create_timer(10).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	rotate(delta)
	move_and_slide()

func _on_damage_area_body_entered(_body: Node2D) -> void:
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(6):
		queue_free()
