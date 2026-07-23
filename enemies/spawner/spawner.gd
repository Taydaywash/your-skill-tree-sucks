extends Node2D

@export var enemy_scene: PackedScene
@export var timer: Timer
@export var indicator_scene: PackedScene
@export var timer_wait_time: float = 1

var spawn_points: Array[Marker2D] = []

func _ready():
	timer.wait_time = timer_wait_time
	
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)

func _process(_delta):
	pass

func spawn_enemy() -> void:
	if not is_inside_tree():
		return
	if not enemy_scene or spawn_points.is_empty():
		return 
		
	var random_position = spawn_points.pick_random()
	var offset = random_position.position_offset
	var spawn_position: Vector2 = random_position.global_position + Vector2(randf_range(-offset, offset), randf_range(-offset, offset))
	
	var indicator = indicator_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", indicator)
	indicator.global_position = spawn_position
	await indicator.tree_exited
	if not is_inside_tree() or get_tree() == null:
		return
	
	var enemy = enemy_scene.instantiate()
	
	get_tree().current_scene.call_deferred("add_child", enemy)
	enemy.global_position = spawn_position

func _on_timer_timeout():
	spawn_enemy()
