extends Area2D

@export var speed: float = 1000
var moving_toward_player: bool = false
var player: Node2D = null

var starting_position
@export var audio_controller: AudioController
@export var evil_xp: AudioStreamWAV
@export var xp_orb: Area2D

func _ready() -> void:
	EventController.level_down.connect(delete_orbs)

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
		audio_controller.play_sound(evil_xp)
		xp_orb.set_deferred("monitoring",false)
		await get_tree().create_timer(0.1).timeout
		call_deferred("queue_free")
		EventController.emit_signal("pick_up_xp_orb")

func delete_orbs() -> void:
	call_deferred("queue_free")
