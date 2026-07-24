extends Area2D

@export var speed: float = 1000
var moving_toward_player: bool = false
var player: Node2D = null

func _physics_process(delta):
	if moving_toward_player and player:
		global_position = global_position.move_toward(player.global_position, speed * delta)

func _on_attraction_area_body_entered(body):
	if body is Player:
		player = body
		moving_toward_player = true

func _on_attraction_area_body_exited(body):
	if body is Player:
		moving_toward_player = false

func _on_xp_orb_body_entered(body):
	if body is Player:
		call_deferred("queue_free")
		EventController.emit_signal("pick_up_xp_orb")
