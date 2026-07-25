extends CharacterBody2D

@export var speed: int 
@export var rock_shot: Sprite2D
var hand : Node

func _ready() -> void:
	await get_tree().process_frame
	rock_shot.look_at(get_global_mouse_position())
	await get_tree().create_timer(10).timeout
	queue_free()

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.get_collision_layer_value(1):
		call_deferred("queue_free")

func _on_damage_area_area_entered(area):
	if area.get_collision_layer_value(5):
		call_deferred("queue_free")
