extends CharacterBody2D
class_name GunBullet

@export var speed : int
var collided_enemy : Node
@export var damage_area: Area2D
var hand : Node
@export var shrapnel_scene: PackedScene
@export var gun_shot: Sprite2D

func _ready() -> void:
	await get_tree().process_frame
	gun_shot.look_at(get_global_mouse_position())
	await get_tree().create_timer(10).timeout
	queue_free()

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if collided_enemy:
		call_deferred("queue_free")
		return
	move_and_slide()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.get_collision_layer_value(1):
		spawn_shrapnel()

func _on_damage_area_area_entered(area):
	if area.get_collision_layer_value(5):
		spawn_shrapnel()

func spawn_shrapnel() -> void:
	var spawn_logic = (func() -> void:
		var backwards_direction = -velocity.normalized()
		
		for i in range(6):
			var shrapnel_piece = shrapnel_scene.instantiate()
			get_tree().current_scene.call_deferred("add_child", shrapnel_piece)
			print("spawn")
			shrapnel_piece.global_position = global_position
			
			var angle = randf_range(-0.60, 0.60)
			var direction = backwards_direction.rotated(angle)
			
			shrapnel_piece.velocity = direction * shrapnel_piece.speed
			shrapnel_piece.global_rotation = direction.angle()
	)

	Callable(spawn_logic).call_deferred()
	call_deferred("queue_free")
