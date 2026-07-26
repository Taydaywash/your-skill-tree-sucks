extends EnemyBullet

var collided_player : Node
@export var damage_area: Area2D
@export var line_2d: Line2D
var return_to_player : bool = false
@export var harpoon_shot: Sprite2D

func _ready() -> void:
	harpoon_shot.look_at(get_global_mouse_position())
	await get_tree().process_frame
	harpoon_shot.look_at(get_global_mouse_position())
	await get_tree().create_timer(1).timeout
	return_to_player = true

func _process(_delta: float) -> void:
	if parent_enemy != null:
		line_2d.set_point_position(0,parent_enemy.global_position - global_position)

func _physics_process(_delta: float) -> void:
	if collided_player:
		global_position = collided_player.global_position
		return
	if return_to_player:
		if parent_enemy != null:
			velocity = (parent_enemy.global_position - global_position).normalized() * speed
			if (global_position - parent_enemy.global_position).length() < 10:
				queue_free()
	move_and_slide()

func _on_damage_area_body_entered_for_harpoon(body: Node2D) -> void:
	if body.get_collision_layer_value(1):
		return_to_player = true
		
func _on_damage_area_area_entered_for_harpoon(body: Node2D) -> void:
	if body.get_collision_layer_value(3):
		damage_area.set_deferred("monitorable", false)
		damage_area.set_deferred("monitoring", false)
		velocity = Vector2.ZERO
		collided_player = body
		return_to_player = true
