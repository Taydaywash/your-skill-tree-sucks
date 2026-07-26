extends CharacterBody2D
class_name Bullet

@export var speed : int
var collided_enemy : Node
@export var damage_area: Area2D
var hand : Node
@export var line_2d: Line2D
var return_to_player : bool = false
@export var harpoon_shot: Sprite2D

func _ready() -> void:
	await get_tree().process_frame
	harpoon_shot.look_at(get_global_mouse_position())
	await get_tree().create_timer(1).timeout
	return_to_player = true

func _process(_delta: float) -> void:
	line_2d.set_point_position(0,hand.global_position - global_position)

func _physics_process(_delta: float) -> void:
	if collided_enemy:
		global_position = collided_enemy.global_position
		return
	if return_to_player:
		velocity = (hand.global_position - global_position).normalized() * speed
		if (global_position - hand.global_position).length() < 10:
			queue_free()
	move_and_slide()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.get_collision_layer_value(1):
		return_to_player = true

func _on_damage_area_area_entered(area):
	if area.get_collision_layer_value(5):
		damage_area.set_deferred("monitorable", false)
		damage_area.set_deferred("monitoring", false)
		velocity = Vector2.ZERO
		collided_enemy = area
		return_to_player = true
