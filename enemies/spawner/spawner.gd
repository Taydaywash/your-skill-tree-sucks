extends Node2D

@export var default_enemy: PackedScene
@export var enemyChance : Dictionary[float,PackedScene]
@export var timer: Timer
@export var indicator_scene: PackedScene
@export var timer_wait_time: float = 1

var spawn_points: Array[Marker2D] = []
var is_spawning: bool = false
var max_enemy_count: int = 200
var current_enemy_count: int = 0

func _ready():
	EventController.level_down.connect(pause_enemies)
	EventController.unpause_enemies.connect(unpause_enemies)
	
	EventController.connect("level_down", add_time)

	timer.wait_time = timer_wait_time
	
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)

func _process(_delta):
	pass

func spawn_enemy() -> void:
	if not is_inside_tree():
		return
	if not enemyChance or spawn_points.is_empty():
		return 
		
	var random_position = spawn_points.pick_random()
	var offset = Vector2(random_position.position_offset_x, random_position.position_offset_y)
	var spawn_position: Vector2 = random_position.global_position + Vector2(randf_range(-offset.x, offset.x), randf_range(-offset.y, offset.y))
	
	var indicator = indicator_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", indicator)
	indicator.global_position = spawn_position
	await indicator.tree_exited
	if not is_inside_tree() or get_tree() == null or not is_spawning:
		return
	
	var final_choice = default_enemy
	#Decrements the choice value by an amount determined by each enemy. Upon reaching zero, select the current entry
	var enemy_choice = randf_range(0,100)
	for entry in enemyChance:
		if enemy_choice - entry <= 0:
			final_choice = enemyChance[entry]
			break
		enemy_choice -= entry
	var enemy = final_choice.instantiate()
	get_tree().current_scene.call_deferred("add_child", enemy)
	enemy.global_position = spawn_position

func _on_timer_timeout():
	if is_spawning and current_enemy_count < max_enemy_count:
		current_enemy_count += 1
		spawn_enemy()
		
func pause_enemies():
	is_spawning = false
	
func unpause_enemies():
	is_spawning = true
	current_enemy_count = 0
	
func add_time():
	timer_wait_time += 0.05
