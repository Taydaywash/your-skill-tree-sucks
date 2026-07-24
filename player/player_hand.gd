extends AnimatedSprite2D
@export var player: Player

var current_weapon = "spear"
@export var animation_player: AnimationPlayer

@export var spear_chargeup_time : float = 0.5
var spear_charged : bool = false
var spear_chargeup_cancelled : bool = false
var spear_chargeup : Timer
@export var spear_raycast: RayCast2D


func _ready() -> void:
	spear_chargeup = Timer.new()
	spear_chargeup.wait_time = spear_chargeup_time
	spear_chargeup.autostart = false
	add_child(spear_chargeup)
	
func _process(_delta: float) -> void:
	if spear_raycast.is_colliding() and not player.movement_disabled:
		player.movement_disabled = true
		player.velocity = (player.position - spear_raycast.get_collision_point()).normalized() * 1000
		#spear_raycast.enabled = false
		await get_tree().create_timer(0.1).timeout
		player.movement_disabled = false
	if animation_player.is_playing():
		return
	position = (get_global_mouse_position() - get_parent().global_position).normalized() * 20
	match current_weapon:
		"spear":
			look_at(get_parent().global_position)
			rotate(PI)
		"fist":
			rotation = 0
		"sword":
			rotation = 0
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("melee_attack"):
		match current_weapon:
			"spear":
				spear_chargeup.start()
				await spear_chargeup.timeout
				animation_player.play("spear_attack")
				await animation_player.animation_finished
			"sword":
				play("sword_idle")
			"fist":
				play("fist_idle")
